import boto3
from botocore.exceptions import ClientError
import json
import re
import os

sts_client = boto3.client('sts')
account = sts_client.get_caller_identity()["Account"]
region = boto3.session.Session().region_name


class EventBridgeTagger:

    def __init__(self, bucket_name, application_domain_json_key):
        self.s3 = boto3.client('s3')
        self.logs = boto3.client('logs')
        self.ssm = boto3.client('ssm')
        self.config = boto3.client('config')
        self.elasticache = boto3.client('elasticache')
        self.bucket_name = bucket_name
        self.application_domain_json_key = application_domain_json_key

    def load_application_domain_json_catalog_from_s3(self):
        '''

        :return: retorna o json (catalogo) de tags de um bucket s3
        '''
        try:
            response = self.s3.get_object(
                    Bucket = self.bucket_name,
                    Key = self.application_domain_json_key
                    )['Body'].read().decode('utf-8')

            return json.loads(response)
        except Exception as e:
            print(f"Error reading JSON from S3: {e}")
            raise

    def get_list_of_words_from_string(self, input_string):
        '''

        :param input_string: recebe uma string
        :return: retorna toda a string em formato de lista sem caracteres especiais..
        '''
        list_of_words = re.sub(r'[^a-zA-Z0-9]', ' ', input_string).split()

        return list_of_words

    def find_matching_search_key_against_list_of_words(self, json_data, resource_words_list):
        '''

        :param json_data: recebe um json (catálogo de tags)
        :param resource_words_list: recebe uma lista de palavras para comparar contra o json_data
        :return: retorna o search_key do json data com maior pontuação na comparação com a lista de palavras.
        '''

        max_correspondence = 0
        best_match = ""

        for item in json_data:
            search_key_value = item.get("search_key", "")
            search_key_value_list = self.get_list_of_words_from_string(
                    search_key_value
                    )
            correspondence = sum(
                    1 for word in resource_words_list if word in search_key_value_list
                    )

            if correspondence > max_correspondence:
                max_correspondence = correspondence
                best_match = search_key_value

        return best_match

    def get_application_domain_values_from_json(self, json_data, search_key):
        '''

        :param json_data: recebe um json (catalogo de tags)
        :param search_key: recebe uma string que corresponde ao search_key no json_data
        :return: Retorna os valores das keys application domain dentro de um bloco com nome search_key
        '''
        matching_item = next(
                (item for item in json_data if item.get(
                        "search_key"
                        ) == search_key), None
                )

        try:
            application_value = matching_item.get("application", "")
            domain_value = matching_item.get("domain", "")

            return application_value, domain_value
        except Exception as e:
            print(
                    f"\nNo match found for search key (application and domain values): {search_key}\n"
                    )
            raise

    def get_value_from_tag_key(self, tags, tag_key):
        '''

        :param tags: recebe um map de tags
        :param tag_key: a tag para procurar seu valor correspondente
        :return: retorna o valor correspondente da tag key com nome 'tag_key' de input.
        '''
        for tag in tags:
            if tag.get('Key') == tag_key & tag.get('Key') != '':
                return tag.get('Value')
            else:
                return ""

    def tag_logs(self, resource_arn, tags):
        try:
            response = self.logs.tag_resource(
                    resourceArn = resource_arn,
                    tags = tags
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_logs\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_config(self, tags):

        try:
            response = self.config.tag_resource(
                    ResourceArn = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_config\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_elasticache(self, resource_arn, tags):
        """
        Adiciona tags a um cluster ElastiCache.

        :param cluster_arn: ARN do cluster ElastiCache.
        :param tags: Lista de dicionários com tags a serem adicionadas.
        :return: Response do serviço.
        """
        try:
            response = self.elasticache.add_tags_to_resource(
                    ResourceName = resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_ssm_parameter(self, resource_arn, tags):
        try:
            response = self.ssm.add_tags_to_resource(
                    ResourceType = 'Parameter',
                    ResourceId = resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {resource_arn}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_config_rule(self, resource_arn, tags):
        try:
            response = self.config.tag_resource(
                    ResourceArn = resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {resource_arn}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def dict_to_array(self, dict):
        array = []

        for key, value in dict.items():
            tag = {'Key': key, 'Value': value}
            array.append(tag)

        return array

    def array_to_dict(self, array):
        array = {item['Key']: item['Value'] for item in array if
                 item['Key'] in ['application', 'domain', 'company',
                                 'rd', 'board', 'shared', 'env']}
        return array

    def tag_resource(self, event_source, resource_arn, tags):
        if "logs" in event_source.lower():
            return self.tag_logs(resource_arn, tags)

        elif "elasticache" in event_source.lower():
            return self.tag_elasticache(resource_arn, tags)

        elif "ssm" in event_source.lower():
            return self.tag_ssm_parameter(resource_arn, tags)

        elif "config" in event_source.lower():
            return self.tag_config_rule(resource_arn, tags)

    def get_tags(self, event_source, resource_arn):
        if "logs" in event_source.lower():
            return self.get_logs_tags(resource_arn)

        elif "elasticache" in event_source.lower():
            return self.get_elasticache_tags(resource_arn)

        elif "config" in event_source.lower():
            return self.get_config_rule_tags(resource_arn)

        elif "ssm" in event_source.lower():
            return self.get_ssm_parameter_tags(resource_arn)

    def get_elasticache_tags(self, resource_arn) -> list:
        response = self.elasticache.list_tags_for_resource(
                ResourceName = resource_arn
                )

        return response['TagList']

    def get_logs_tags(self, resource_arn) -> dict:
        response = self.logs.list_tags_for_resource(
                resourceArn = resource_arn
                )

        return response['tags']

    def get_ssm_parameter_tags(self, resource_arn) -> list:
        response = self.ssm.list_tags_for_resource(
                ResourceType = 'Parameter',
                ResourceId = resource_arn
                )
        return response['TagList']

    def get_config_rule_tags(self, resource_arn) -> list:
        response = self.config.list_tags_for_resource(
                ResourceArn = resource_arn
                )

        return response['Tags']


def check_defined(reference, reference_name):
    if not reference:
        raise Exception('Error: ', reference_name, 'is not defined')
    return reference


def lambda_handler(event, context):
    '''
    Cada evento represena 1 recurso. Para cada recurso é comparado suas tags um catálogo de tags de referência.
    Se fora de conformidade o recurso é tagueado.
    :param event: payload do eventbridge
    :return: resposta da api de tagueamento ou que o recurso já está em compliance com o catálogo.
    '''
    event_source = event["source"]
    print(f"Event: {event}\n")
    print(f"EVENT SOURCE: {event_source}\n")
    resource_key_words = []
    resource_arn = ""

    # cada source (logs, elasticache, ssm, config) possui uma estrutura de payload diferente.
    if 'logs' in event_source:
        if "resourceArn" in event["detail"]["requestParameters"].keys():
            resource_arn = event["detail"]["requestParameters"]["resourceArn"]

        elif "logGroupName" in event["detail"]["requestParameters"].keys():
            log_group = event["detail"]["requestParameters"]["logGroupName"]
            resource_arn = f"arn:aws:logs:{region}:{account}:log-group:{log_group}"
            resource_key_words.extend(["logs"])

    elif 'elasticache' in event_source:
        resource_arn = event["detail"]["requestParameters"]["resourceName"]
        resource_key_words.extend(["elasticache"])

    elif 'config' in event_source:
        if "resourceArn" in event["detail"]["requestParameters"].keys():
            resource_arn = event["detail"]["requestParameters"]["resourceArn"]

        elif "configRuleArn" in event["detail"]["requestParameters"]["configRule"].keys():
            resource_arn = event["detail"]["requestParameters"]["configRule"]["configRuleArn"]

    elif 'ssm' in event_source:
        resource_arn = event["detail"]["requestParameters"]["resourceId"]
        resource_key_words.extend(["ssm"])

    else:
        raise Exception('event source não identificado. Recrusosos suportados: SSM, CONFIG, ELASTICACHE, LOGS')

    required_tags = {}

    lambda_action = EventBridgeTagger(
            bucket_name = os.environ.get("BUCKET_NAME"),
            application_domain_json_key = os.environ.get("BUCKET_KEY"),
            )

    resource_tags = lambda_action.get_tags(event_source, resource_arn)

    # normalizar a estrutura de tags para formato lista
    if isinstance(resource_tags, dict):
        resource_tags = lambda_action.dict_to_array(resource_tags)

    json_data = lambda_action.load_application_domain_json_catalog_from_s3()
    print(f'json data -> {json_data}')

    resource_key_words.extend(
            lambda_action.get_list_of_words_from_string(
                    input_string = resource_arn
                    )
            )

    print(f'Lista de palavras a partir do arn: {resource_key_words}')

    print(f'\nRESOURCE TAGS -> {resource_tags}\n')

    try:
        for item in resource_tags:
            if item['Key'] == 'Name' and item['Value']:
                resource_tag_name = item['Value']
                resource_tag_name_list = lambda_action.get_list_of_words_from_string(
                        input_string = resource_tag_name
                        )
                resource_key_words.extend(resource_tag_name_list)

            if 'eks' in item['Key'] or 'spot' in item['Key'] or 'cluster' in item['Key'] or 'node' in item[
                'Key'] or 'k8s' in item['Key']:
                resource_key_words.extend(
                        ["eks", "cluster", "spotinst", "spot", "kubernetes", "node", "nodegroup", "group"]
                        )
                if item['eks:cluster-name']:
                    resource_key_words.extend([item['eks:cluster-name']])
                if item['eks:nodegroup-name']:
                    resource_key_words.extend([item['eks:nodegroup-name']])

        print(f"Lista de palavras + TagName e Tags EKS, se houver -> {resource_key_words}\n")
    except Exception as e:
        print(f'\n exception No tag Name found-> {e}')
        print(f'continuing...')

    try:
        search_key = lambda_action.find_matching_search_key_against_list_of_words(
                json_data = json_data, resource_words_list = resource_key_words
                )
        print(f'\nsearch_key -> {search_key}')
    except Exception as e:
        print(f'\nNão foi possivel encontrar search_key\n')
        raise

    try:
        application, domain = lambda_action.get_application_domain_values_from_json(
                search_key = search_key, json_data = json_data
                )

        print(f'aplication:{application} domain:{domain}')

        # normalizar estrutura de tags para formato de dicionário
        if isinstance(resource_tags, list):
            required_tags = lambda_action.array_to_dict(resource_tags)

        required_tags['application'] = application
        required_tags['domain'] = domain
        required_tags['board'] = os.environ.get("TAG_BOARD")
        required_tags['company'] = os.environ.get("TAG_COMPANY")
        required_tags['shared'] = os.environ.get("TAG_SHARED")
        required_tags['env'] = os.environ.get("TAG_ENV")


    except Exception as e:
        print(
                f'\nNão foi possivel gerar tags application e/ou domain -> \n{e}\n'
                )
        raise

    # comparação das tags do recurso (resource_tags) e do catálog (required_tags) em formato de dicionário
    if required_tags == lambda_action.array_to_dict(resource_tags):
        print(f'\nREQUIRED TAGS: \n {required_tags}')
        print(f'\nRESOURCE TAGS: \n {resource_tags}')
        print("NOTHING TO DO, TAG IS COMPLIANT")
        return "Nothing to do, tag is COMPLIANT"

    # add info tags
    # required_tags['lambda_automation'] = "event_bridge_tagger"

    response = lambda_action.tag_resource(event_source, resource_arn, required_tags)

    print(f'\n ### response \n {response} \n########')

    return response
