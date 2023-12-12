import boto3
from botocore.exceptions import ClientError
import json
import re


class GuessTagsWithCatalog:

    def __init__(self, bucket_name, application_domain_json_key, resourceID, conformance_pack_name):
        self.taggingapi = boto3.client('resourcegroupstaggingapi')
        self.s3 = boto3.client('s3')
        self.elb = boto3.client('elb')
        self.elbv2 = boto3.client('elbv2')
        self.athena = boto3.client('athena')
        self.secretsmanager = boto3.client('secretsmanager')
        self.sqs = boto3.client('sqs')
        self.sns = boto3.client('sns')
        self.ec2 = boto3.client('ec2')
        self.backup = boto3.client('backup')
        self.networkmanager = boto3.client('networkmanager')
        self.autoscaling = boto3.client('autoscaling')
        self.rds = boto3.client('rds')
        self.mq = boto3.client('mq')
        self.ecr = boto3.client('ecr')
        self.cloudtrail = boto3.client('cloudtrail')
        self.ecs = boto3.client('ecs')
        self.cloudfront = boto3.client('cloudfront')
        self.cloudwatch = boto3.client('cloudwatch')
        self.logs = boto3.client('logs')
        self.redshift = boto3.client('redshift')
        self.emr = boto3.client('emr')
        self.guardduty = boto3.client('guardduty')
        self.events = boto3.client('events')
        self.opensearch = boto3.client('opensearch')
        self.eks = boto3.client('eks')
        self.ssm = boto3.client('ssm')
        self.config = boto3.client('config')
        self.lambda_func = boto3.client('lambda')
        self.elasticache = boto3.client('elasticache')
        self.bucket_name = bucket_name
        self.application_domain_json_key = application_domain_json_key
        self.conformance_pack_name = conformance_pack_name
        self.resource_id = resourceID
        self.resource_type, self.resource_arn, self.ordering_timestamp, self.config_rule_name = self.get_resource_arn_and_type_from_compliance_details()

    def get_resource_arn_and_type(self):
        '''

        :return: retorna o tipo do recruso e o arn do recruso.
        '''
        return self.resource_type, self.resource_arn

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
    def get_mq_tags(self) -> dict:
        '''

        :return: tags do rabbit MQ
        '''
        try:
            response = self.mq.list_tags(
                    ResourceArn = self.resource_arn
                    )
            return response["Tags"]
        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do mq {e}')

    def get_eks_tags(self) -> dict:
        '''

        :return: Tags do cluster eks
        '''
        try:
            response = self.eks.list_tags_for_resource(
                    resourceArn = self.resource_arn
                    )
            return response["tags"]
        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do eks {e}')

    def get_athena_tags(self) -> list:
        '''

        :return: tags do athena
        '''
        try:
            response = self.athena.list_tags_for_resource(
                    ResourceARN = self.resource_arn,
                    MaxResults = 100
                    )
            return response["Tags"]

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do athena {e}')

    def get_backup_tags(self) -> dict:
        '''

        :return: tags do aws backup
        '''
        try:
            response = self.backup.list_tags(
                    ResourceArn = self.resource_arn,
                    MaxResults = 100
                    )
            return response["Tags"]

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do event {e}')

    def get_event_tags(self) -> dict:
        '''

        :return: tags do event bridge
        '''
        try:
            response = self.events.list_tags_for_resource(
                    ResourceARN = self.resource_arn,
                    )
            return response["Tags"]

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do eventBridge {e}')


    def get_secretsmanager_tags(self) -> list:
        '''

        :return: lista de tags do secret manager
        '''
        try:
            response = self.secretsmanager.describe_secret(
                    SecretId = self.resource_arn,
                    )
            return response['Tags']

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do secretsmanager {e}')

    def get_guardduty_tags(self) -> dict:
        '''

        :return: dicionário de tags do guard duty (dict)
        '''
        try:
            response = self.guardduty.list_tags_for_resource(
                    ResourceArn = self.resource_arn,
                    )
            return response["Tags"]

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do guardduty {e}')

    def get_networkmanager_tags(self) -> list:
        '''

        :return: lista de tags do networkmanager
        '''
        try:
            response = self.networkmanager.list_tags_for_resource(
                    ResourceArn = self.resource_arn,
                    )
            return response["TagList"]

        except Exception as e:
            raise Exception(f'Não foi possivel listar tags do networkmanager {e}')

    def get_tags(self):
        '''

        :return: lista ou dicionário de tags.
        '''

        if ":mq:" in self.resource_type.lower():
            return self.get_mq_tags()

        elif ":eks:" in self.resource_type.lower():
            return self.get_eks_tags()

        elif ":athena:" in self.resource_type.lower():
            return self.get_athena_tags()

        elif ":backup:" in self.resource_type.lower():
            return self.get_backup_tags()

        elif ":events:" in self.resource_type.lower():
            return self.get_event_tags()

        elif ":secretsmanager:" in self.resource_type.lower():
            return self.get_secretsmanager_tags()

        elif ":guardduty:" in self.resource_type.lower():
            return self.get_guardduty_tags()

        elif ":networkmanager:" in self.resource_type.lower():
            return self.get_networkmanager_tags()

        else:
            return self.get_tags_from_taggingapi()

    def get_tags_from_taggingapi(self) -> list:
        '''

        :return: lista de tags
        '''
        try:
            response = self.taggingapi.get_resources(
                    ResourceARNList = [self.resource_arn]
                    )['ResourceTagMappingList'][0]['Tags']
            return response
        except Exception as e:
            print(f"O recurso não possui tags ou não é suportado pela api do tag editor: {e}")

    def get_list_of_words_from_string(self, input_string) -> list:
        '''

        :param input_string: recebe uma string
        :return: retorna lista de palavras
        '''
        list_of_words = re.sub(r'[^a-zA-Z0-9 ]', ' ', input_string).split()

        return list_of_words

    def find_matching_search_key_against_list_of_words(self, json_data, resource_words_list):
        '''

        :param json_data: recebe um json (catálogo de tags)
        :param resource_words_list: recebe uma lista de palavras
        :return: retorna string - search_key do json_data com maior correspondênica de palavras
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

    def get_resource_arn_and_type_from_compliance_details(self):
        '''
        Function que coleta informações do recurso a partir da config rule de origem.
        :return: retorna resource_type, resource_arn, ordering_timestamp, config_rule_name do recurso
        '''
        filters = {'ComplianceType': 'NON_COMPLIANT'}
        next_token = None
        full_response = []

        while True:
            if next_token:
                response = self.config.get_conformance_pack_compliance_details(
                        ConformancePackName = self.conformance_pack_name,
                        Filters = filters,
                        Limit = 100,
                        NextToken = next_token
                        )

            else:
                response = self.config.get_conformance_pack_compliance_details(
                        ConformancePackName = self.conformance_pack_name,
                        Filters = filters,
                        Limit = 100,
                        )

            conformance_results = response['ConformancePackRuleEvaluationResults']
            full_response.extend(conformance_results)
            next_token = response.get('NextToken')

            if not next_token:
                break

        for item in full_response:
            current_id = item['EvaluationResultIdentifier']['EvaluationResultQualifier']['ResourceId']
            if self.resource_id == current_id:
                resource_type = item['EvaluationResultIdentifier']['EvaluationResultQualifier']['ResourceType']
                config_rule_name = item['EvaluationResultIdentifier']['EvaluationResultQualifier']['ConfigRuleName']
                ordering_timestamp = item['EvaluationResultIdentifier']['OrderingTimestamp']
                resource_arn = self.config.batch_get_resource_config(
                        resourceKeys = [
                            {
                                'resourceType': f'{resource_type}',
                                'resourceId':   f'{self.resource_id}'
                                }
                            ]
                        )['baseConfigurationItems'][0]['arn']

                return resource_type, resource_arn, ordering_timestamp, config_rule_name


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

    def tag_ec2(self, tags):

        try:
            response = self.ec2.create_tags(
                    Resources = [self.resource_id],
                    Tags = self.dict_to_array(tags)
                    )
            print(f'response ec2 tag {response}')

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_ec2\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_s3(self, tags):
        try:
            response = self.s3.put_bucket_tagging(
                    Bucket = self.resource_id,
                    Tagging = {
                        'TagSet': self.dict_to_array(tags)
                        }
                    )
            print(f'response s3 tag {response}')

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_s3\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_rds(self, tags):
        try:
            response = self.rds.add_tags_to_resource(
                    ResourceName = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_rds\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_mq(self, tags):
        try:
            response = self.mq.create_tags(
                    ResourceArn = self.resource_arn,
                    Tags = tags
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_mq\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_ecr(self, tags):
        try:
            response = self.ecr.tag_resource(
                    resourceArn = self.resource_arn,
                    tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_ecr\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_ecs(self, tags):
        try:
            response = self.ecs.tag_resource(
                    resourceArn = self.resource_arn,
                    tags = self.dict_to_array(tags)
                    )

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_ecs\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_cloudfront(self, tags):
        try:
            response = self.cloudfront.tag_resource(
                    Resource = self.resource_arn,
                    Tags = {
                        'Items': self.dict_to_array(tags)
                        }
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_cloudfront\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_cloudwatch(self, tags):
        try:
            response = self.cloudwatch.tag_resource(
                    ResourceARN = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_cloudwatch\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_logs(self, tags):
        try:
            response = self.logs.tag_resource(
                    resourceArn = self.resource_arn,
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

    def tag_redshift(self, tags):
        try:
            response = self.redshift.create_tags(
                    ResourceName = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_redshift\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def emr_tag_resource(self, tags):
        try:

            response = self.emr.add_tags(
                    ResourceId = self.resource_id,
                    Tags = self.dict_to_array(tags)
                    )

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: emr_tag_resource\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_opensearch(self, tags):
        try:
            response = self.opensearch.add_tags(
                    ARN = self.resource_arn,
                    TagList = self.dict_to_array(tags)
                    )

            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: emr_tag_resource\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_eks(self, tags):
        try:
            response = self.eks.tag_resource(
                    resourceArn = self.resource_arn,
                    tags = tags
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_eks\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_athena(self, tags):
        try:
            response = self.athena.tag_resource(
                    ResourceARN = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_athena\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_autoscaling(self, tags):
        '''
        tagueia autoscaling group a partir do arn (aws config exporta o resource_id desse recurso como arn)
        "arn:aws:autoscaling:us-east-1:979394123881:autoScalingGroup:f7031224-37ef-418f-9c70-cda4f5d13353:autoScalingGroupName/eks-core-2022090520570595890000000f-f8c187b8-a46f-464b-831e-bbedf7312905"
        é selecionado apenas o autoscaling group name.
        :param tags:
        :return:
        '''
        tag_array = []
        pattern = re.compile(r'.*:autoScalingGroupName/')

        for key, value in tags.items():
            tag = {
                'ResourceId':        re.sub(pattern, '', self.resource_id),
                'ResourceType':      "auto-scaling-group",
                'Key':               key,
                'Value':             value,
                'PropagateAtLaunch': True
                }
            tag_array.append(tag)

        try:
            response = self.autoscaling.create_or_update_tags(
                    Tags = tag_array
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_autoscaling\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def iam_tag_resource(self, tags):
        try:
            if "policy" in self.resource_type.lower():

                response = self.iam.tag_policy(
                        PolicyArn = self.resource_arn,
                        Tags = self.dict_to_array(tags)
                        )
                return response

            elif "role" in self.resource_type.lower():
                response = self.iam.tag_role(
                        RoleName = self.resource_arn,
                        Tags = self.dict_to_array(tags)
                        )
                return response

            elif "user" in self.resource_type.lower():
                response = self.iam.tag_user(
                        UserName = self.resource_id,
                        Tags = self.dict_to_array(tags)
                        )

                return response

            elif "saml" in self.resource_type.lower():
                response = self.iam.tag_saml_provider(
                        UserName = self.resource_arn,
                        Tags = self.dict_to_array(tags)
                        )

                return response

            elif "profile" in self.resource_type.lower():
                response = self.iam.tag_instance_profile(
                        UserName = self.resource_id,
                        Tags = self.dict_to_array(tags)
                        )

                return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: iam_tag_resource\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_elb(self, tags):
        try:

            response = self.elb.add_tags(
                    LoadBalancerNames = [
                        self.resource_id
                        ],
                    Tags = self.dict_to_array(tags)
                    )
            return response


        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_elb\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_elbv2(self, tags):
        try:

            response = self.elbv2.add_tags(
                    ResourceArns = [
                        self.resource_arn
                        ],
                    Tags = self.dict_to_array(tags)
                    )
            return response


        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_elbv2\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {self.dict_to_array(tags)}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_lambda_func(self, tags):

        try:

            response = self.lambda_func.tag_resource(
                    Resource = self.resource_arn,
                    Tags = tags
                    )
            return response


        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_lambda_func\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_sqs(self, tags):
        try:

            response = self.sqs.tag_resource(
                    QueueUrl = self.resource_id,
                    Tags = tags
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_sqs\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_sns(self, tags):
        try:

            response = self.sns.tag_resource(
                    ResourceArn = self.resource_arn,
                    Tags = self.dict_to_array(tags)
                    )
            return response
        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print("Funçao: tag_sns\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_elasticache(self, tags):
        """
        Adiciona tags a um cluster ElastiCache.

        :param cluster_arn: ARN do cluster ElastiCache.
        :param tags: Lista de dicionários com tags a serem adicionadas.
        :return: Response do serviço.
        """
        try:
            response = self.elasticache.tag_resource(
                    ResourceArn = self.resource_arn,
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

    def tag_ssm_parameter(self, tags):
        try:
            response = self.ssm.add_tags_to_resource(
                    ResourceType = 'Parameter',
                    ResourceId = self.resource_id,
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

    def tag_backup(self, tags):
        try:
            response = self.backup.tag_resource(
                    ResourceArn = self.resource_arn,
                    Tags = tags
                    )
            return response

        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_events(self, tags):
        print(f'EVENT BRIDGE ARN: {self.resource_arn}\n')
        try:
            response = self.events.tag_resource(
                    ResourceARN = self.resource_arn,
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

    def tag_secretsmanager(self, tags):
        try:
            response = self.secretsmanager.tag_resource(
                    SecretId = self.resource_id,
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

    def tag_guardduty(self, tags):
        try:
            response = self.guardduty.tag_resource(
                    ResourceArn = self.resource_arn,
                    Tags = tags
                    )
            return response
        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
            print(f"Tags: {tags}\n")
            print(f"error: \n{e}\n")
            raise

    def tag_networkmanager(self, tags):
        try:
            response = self.networkmanager.tag_resource(
                    ResourceArn = self.resource_arn,
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

    def tag_cloudtrail(self, tags):
        try:
            response = self.cloudtrail.tag_resource(
                    ResourceId = self.resource_id,
                    TagsList = self.dict_to_array(tags)
                    )
            return response
        except ClientError as e:
            print("\nNão foi possivel taguear recurso:\n")
            print(f"arn: {self.resource_arn}\n")
            print(f"resourceId: {self.resource_id}\n")
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


    def tag_resource(self, tags):
        '''

        :param tags: tags em formato de dicionário
        :return: resposta da chamada de api to recurso tagueado
        '''
        if ":ec2:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_ec2(tags)

        elif ":rds:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_rds(tags)

        elif ":mq:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_mq(tags)

        elif ":ecs:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_ecs(tags)

        elif ":ecr:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_ecr(tags)

        elif ":cloudfront:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_cloudfront(tags)

        elif ":cloudwatch:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_cloudwatch(tags)

        elif ":logs:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_logs(tags)

        elif ":config:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_config(tags)

        elif ":redshift:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_redshift(tags)

        elif ":opensearch:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_opensearch(tags)

        elif ":eks:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_eks(tags)

        elif ":s3:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_s3(tags)

        elif ":autoscaling:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_autoscaling(tags)

        elif ":elasticloadbalancingv2:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_elbv2(tags)

        elif ":elasticloadbalancing:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_elb(tags)

        elif ":lambda:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_lambda_func(tags)

        elif ":athena:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_athena(tags)

        elif ":sqs:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_sqs(tags)

        elif ":sns:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_sns(tags)

        elif ":elasticache:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_elasticache(tags)

        elif ":parameter:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_ssm_parameter(tags)

        elif ":backup:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_backup(tags)

        elif ":events:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_events(tags)

        elif ":secretsmanager:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_secretsmanager(tags)

        elif ":guardduty:" in self.resource_type.lower():
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_guardduty(tags)

        elif ":networkmanager:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_networkmanager(tags)


        elif ":cloudtrail:" in self.resource_type.lower():
            tags['shared'] = 'yes'
            print(
                    f'\nTaggued resource: {self.resource_id}, {self.resource_type}\n'
                    )
            return self.tag_cloudtrail(tags)


def set_required_tags_handler(event, context):
    '''
    Cada evento representa 1 recurso. Essa function Utiliza da classe GuessTagsWithCatalog para coletar
    informações do recurso (arn, tipo e tags), encontrar as devidas tags a partir de um catálogo armazenado
    em um bucket s3 para o recurso e taguear o recurso. A execução deste script pelo aws config pressupõe que
    as tags estão fora de conformidade com o catálogo.
    :param event: evento do aws config
    :return: resposta da api de tagueamento
    '''
    required_tags = json.loads(event['RequiredTags'])
    json_data = {}
    resource_type = ""
    resource_arn = ""
    resource_tags = []
    resource_key_words = []
    resource_tag_name_list = []

    ssm_action = GuessTagsWithCatalog(
            bucket_name = event['BucketS3Name'],
            application_domain_json_key = event['BucketS3ApplicationDomainKey'],
            conformance_pack_name = event['ConformancePackName'],
            resourceID = event['ResourceID']
            )

    json_data = ssm_action.load_application_domain_json_catalog_from_s3()
    resource_type, resource_arn = ssm_action.get_resource_arn_and_type()
    resource_key_words = ssm_action.get_list_of_words_from_string(
            input_string = resource_arn
            )

    resource_tags = ssm_action.get_tags()

    if isinstance(resource_tags, dict):
        resource_tags = ssm_action.dict_to_array(resource_tags)

    print(f"\nresource_arn -> {resource_arn}")
    print(f"resource_type -> {resource_type}")
    print(f"resource tags -> {resource_tags}")
    print(f"Lista de palavras a partir do arn -> {resource_key_words}\n")

    try:
        for item in resource_tags:
            if item['Key'] == 'Name' and item['Value']:
                resource_tag_name = item['Value']
                resource_tag_name_list = ssm_action.get_list_of_words_from_string(
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
        search_key = ssm_action.find_matching_search_key_against_list_of_words(
                json_data = json_data, resource_words_list = resource_key_words
                )
        print(f'\nsearch_key -> {search_key}')
    except Exception as e:
        print(f'\nNão foi possivel encontrar search_key\n')
        raise

    try:
        application, domain = ssm_action.get_application_domain_values_from_json(
                search_key = search_key, json_data = json_data
                )

        print(f'aplication:{application} domain:{domain}')

        required_tags['application'] = application
        required_tags['domain'] = domain

        # info tags
        # required_tags['config_automation'] = ssm_action.config_rule_name

    except Exception as e:
        print(
                f'\nNão foi possivel gerar tags application e/ou domain -> \n{e}\n'
                )
        raise
    response = ssm_action.tag_resource(tags = required_tags)

    print(f'\n ### response \n {response} \n########')

    return response
