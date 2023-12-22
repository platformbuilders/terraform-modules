import botocore
import boto3
import json
import datetime
import botocore.exceptions

# Set to True to get the lambda to assume the Role attached on the Config Service (useful for cross-account).
ASSUME_ROLE_MODE = False

# This gets the client after assuming the Config service role
# either in the same AWS account or cross-account.
def get_client(service, event):
    """Return the service boto client. It should be used instead of directly calling the client.
    Keyword arguments:
    service -- the service name used for calling the boto.client()
    event -- the event variable given in the lambda handler
    """
    if not ASSUME_ROLE_MODE:
        return boto3.client(service)
    credentials = get_assume_role_credentials(event["executionRoleArn"])
    return boto3.client(service, aws_access_key_id=credentials['AccessKeyId'],
                        aws_secret_access_key=credentials['SecretAccessKey'],
                        aws_session_token=credentials['SessionToken']
                       )

# Helper function used to validate input
def check_defined(reference, reference_name):
    '''

    :param reference: string
    :param reference_name: string reference name
    :return: reference if string exists
    '''
    if not reference:
        raise Exception('Error: ', reference_name, 'is not defined')
    return reference

# Check whether the message is OversizedConfigurationItemChangeNotification or not
def is_oversized_changed_notification(message_type):
    '''

    :param message_type:
    :return: message type  = oversized
    '''
    check_defined(message_type, 'messageType')
    return message_type == 'OversizedConfigurationItemChangeNotification'

# Get configurationItem using getResourceConfigHistory API
# in case of OversizedConfigurationItemChangeNotification
def get_configuration(resource_type, resource_id, configuration_capture_time):
    '''

    :param resource_type:
    :param resource_id:
    :param configuration_capture_time:
    :return: converted config rule payload
    '''
    result = AWS_CONFIG_CLIENT.get_resource_config_history(
        resourceType=resource_type,
        resourceId=resource_id,
        laterTime=configuration_capture_time,
        limit=1)
    configurationItem = result['configurationItems'][0]
    return convert_api_configuration(configurationItem)

# Convert from the API model to the original invocation model
def convert_api_configuration(configurationItem):
    '''
    convert api configuration payload
    :param configurationItem: config rule payload
    :return: payload converted to api configuration
    '''
    for k, v in configurationItem.items():
        if isinstance(v, datetime.datetime):
            configurationItem[k] = str(v)
    configurationItem['awsAccountId'] = configurationItem['accountId']
    configurationItem['ARN'] = configurationItem['arn']
    configurationItem['configurationStateMd5Hash'] = configurationItem['configurationItemMD5Hash']
    configurationItem['configurationItemVersion'] = configurationItem['version']
    configurationItem['configuration'] = json.loads(configurationItem['configuration'])
    if 'relationships' in configurationItem:
        for i in range(len(configurationItem['relationships'])):
            configurationItem['relationships'][i]['name'] = configurationItem['relationships'][i]['relationshipName']
    return configurationItem

# Based on the type of message get the configuration item
# either from configurationItem in the invoking event
# or using the getResourceConfigHistory API in getConfiguration function.
def get_configuration_item(invokingEvent):
    check_defined(invokingEvent, 'invokingEvent')
    if is_oversized_changed_notification(invokingEvent['messageType']):
        configurationItemSummary = check_defined(invokingEvent['configurationItemSummary'], 'configurationItemSummary')
        return get_configuration(configurationItemSummary['resourceType'], configurationItemSummary['resourceId'], configurationItemSummary['configurationItemCaptureTime'])
    return check_defined(invokingEvent['configurationItem'], 'configurationItem')

# Check whether the resource has been deleted. If it has, then the evaluation is unnecessary.
def is_applicable(configurationItem, event):
    try:
        check_defined(configurationItem, 'configurationItem')
        check_defined(event, 'event')
    except:
        return True
    status = configurationItem['configurationItemStatus']
    eventLeftScope = event['eventLeftScope']
    if status == 'ResourceDeleted':
        print("Resource Deleted, setting Compliance Status to NOT_APPLICABLE.")
    return (status == 'OK' or status == 'ResourceDiscovered') and not eventLeftScope

def get_assume_role_credentials(role_arn):
    sts_client = boto3.client('sts')
    try:
        assume_role_response = sts_client.assume_role(RoleArn=role_arn, RoleSessionName="configLambdaExecution")
        return assume_role_response['Credentials']
    except botocore.exceptions.ClientError as ex:
        # Scrub error message for any internal account info leaks
        if 'AccessDenied' in ex.response['Error']['Code']:
            ex.response['Error']['Message'] = "AWS Config does not have permission to assume the IAM role."
        else:
            ex.response['Error']['Message'] = "InternalError"
            ex.response['Error']['Code'] = "InternalError"
        raise ex

def evaluate_tags_compliance(configuration_item, rule_parameters):
    '''

    :param configuration_item:
    :param rule_parameters:
    :return: COMPLIANT | NON_COMPLIANT
    '''
    tag_parameter = {}

    check_defined(configuration_item['configuration'], 'configuration_item[\'configuration\']')

    if rule_parameters:
        check_defined(rule_parameters, 'rule_parameters')

    resource_tags = configuration_item['tags']

    if rule_parameters:
        check_defined(rule_parameters, 'rule_parameters')

    try:

        for k, v in rule_parameters.items():
            if "key" in k:
                key_value = k
                tag_parameter[rule_parameters[k]] = rule_parameters[v]

        # converte a estrutura de dados para {key:value}.
        for i in range(1, 7):
            key = f"tag{i}Key"
            value = f"tag{i}Value"
            if key in rule_parameters:
                if ',' in rule_parameters[value]:
                    tag_parameter[rule_parameters[key]] = rule_parameters[value].replace(' ', '').split(',')
                else:
                    tag_parameter[rule_parameters[key]] = rule_parameters[value]

        for k, v in tag_parameter.items():
            # checa se todas chaves existem no recurso
            if k not in resource_tags:
                print(f'Chave "{k}" nao presente no recurso')
                return "NON_COMPLIANT"
            # checa se todas as chaves possuem os valores corretos.
            elif resource_tags[k] not in v:
                print(f'Valor da tag key {k}:{resource_tags[k]} diferente de: {v}')
                return "NON_COMPLIANT"

    except json.JSONDecodeError:
        return "Invalid JSON format in ruleParameters"

    return "COMPLIANT"

def lambda_handler(event, context):
    '''
    Cada evento representa 1 recurso. Notifica a config rule se as tags do recurso estão em conformidade com o catálogo
    de tags de referência.
    :param event: payload do aws config para o recurso
    :return: COMPLIANT | NON_COMPLIANT
    '''
    global AWS_CONFIG_CLIENT

    print("#############\n")
    print(f"event ECR: {event}\n")

    check_defined(event, 'event')
    invoking_event = json.loads(event['invokingEvent'])
    rule_parameters = {}
    if 'ruleParameters' in event:
        rule_parameters = json.loads(event['ruleParameters'])

    compliance_value = 'NOT_APPLICABLE'

    AWS_CONFIG_CLIENT = get_client('config', event)
    configuration_item = get_configuration_item(invoking_event)
    print("#############\n")
    print(f"configuration_item: {configuration_item}\n")
    if is_applicable(configuration_item, event):
        compliance_value = evaluate_tags_compliance(
                configuration_item, rule_parameters)

    response = AWS_CONFIG_CLIENT.put_evaluations(
       Evaluations=[
           {
               'ComplianceResourceType': invoking_event['configurationItem']['resourceType'],
               'ComplianceResourceId': invoking_event['configurationItem']['resourceId'],
               'ComplianceType': compliance_value,
               'OrderingTimestamp': invoking_event['configurationItem']['configurationItemCaptureTime']
           },
       ],
       ResultToken=event['resultToken'])

    print("RESPONSE \n\n")
    print(response)