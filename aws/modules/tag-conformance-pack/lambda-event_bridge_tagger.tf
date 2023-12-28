module "event_bridge_tagger" {
  source          = "terraform-aws-modules/lambda/aws"
  create_function = var.create_event_bridge_tagger

  function_name = "event_bridge_tagger"
  description   = "lambda que dispara conforme o event bridge que identifica recursos modificados, criados ou com tags ajustadas"
  handler       = "${trimsuffix(var.event_bridge_tagger_script, ".py")}.lambda_handler"
  runtime       = "python3.10"
  create        = var.create_event_bridge_tagger
  source_path   = "${var.script_path}/${var.event_bridge_tagger_script}"

  attach_create_log_group_permission = true
  cloudwatch_logs_retention_in_days  = 1
  architectures                      = ["x86_64"]
  create_role                        = true
  role_name                          = "lambda_tag_by_resource_change"
  publish                            = true

  attach_policies    = true
  policies           = [module.TagRemediationAutomationPolicy.arn, module.TagRemediationAutomationS3AccessPolicy.arn]
  number_of_policies = 2

  environment_variables = {
    BUCKET_NAME = var.bucket_name
    BUCKET_KEY  = aws_s3_object.application_domain_json.id
    TAG_BOARD   = var.tags["board"]
    TAG_COMPANY = var.tags["company"]
    TAG_SHARED  = var.tags["shared"]
    TAG_ENV     = var.tags["env"]
  }

  allowed_triggers = {
    cloudwatch_logs_event_rule_trigger = {
      principal  = "events.amazonaws.com"
      source_arn = var.create_event_bridge_tagger ? aws_cloudwatch_event_rule.cloudwatch_logs_trigger[0].arn : ""
    }

    elasticache_event_rule_trigger = {
      principal  = "events.amazonaws.com"
      source_arn = var.create_event_bridge_tagger ? aws_cloudwatch_event_rule.elasticache_trigger[0].arn : ""

    }

    ssm_parameter_event_rule_trigger = {
      principal  = "events.amazonaws.com"
      source_arn = var.create_event_bridge_tagger ? aws_cloudwatch_event_rule.ssm_parameter_trigger[0].arn : ""

    }
    config_event_rule_trigger = {
      principal  = "events.amazonaws.com"
      source_arn = var.create_event_bridge_tagger ? aws_cloudwatch_event_rule.config_rule_trigger[0].arn : ""

    }
  }

  timeout = 600

}

##################################
# Cloudwatch Events (EventBridge)
##################################
resource "aws_cloudwatch_event_rule" "elasticache_trigger" {
  count         = var.create_event_bridge_tagger ? 1 : 0
  name          = "elasticache_events"
  description   = "Check resource tags for resource event"
  # olhar os event names na doc da api do recurso
  event_pattern = <<PATTERN
{
  "source": ["aws.elasticache"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["elasticache.amazonaws.com"],
    "eventName": ["CreateCacheCluster", "CreateReplicationGroup", "ModifyCacheCluster", "RemoveTagsFromResource", "AddTagsToResource"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_rule" "ssm_parameter_trigger" {
  count         = var.create_event_bridge_tagger ? 1 : 0
  name          = "ssm_parameter_events"
  description   = "Check resource tags for resource event"
  # olhar os event names na doc da api do recurso
  event_pattern = <<PATTERN
{
  "source": ["aws.ssm"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ssm.amazonaws.com"],
    "eventName": ["AddTagsToResource","RemoveTagsFromResource","PutParameter"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_rule" "cloudwatch_logs_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0

  name          = "cloudwatch_logs_events"
  description   = "Check resource tags for resource event"
  # olhar os event names na doc da api do recurso
  event_pattern = <<PATTERN
{
  "source": ["aws.logs"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["logs.amazonaws.com"],
    "eventName": ["CreateLogGroup","TagLogGroup","UntagLogGroup","TagResource","UntagResource"]
  }
}

PATTERN
}

resource "aws_cloudwatch_event_rule" "config_rule_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0

  name          = "config_rule_events"
  description   = "Check resource tags for resource event"
  # olhar os event names na doc da api do recurso
  event_pattern = <<PATTERN
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "config.amazonaws.com"
    ],
    "eventName": [
      "TagResource",
      "UntagResource",
      "PutConfigRule",
      "PutConformancePack",
      "StartRemediationExecution",
      "PutRemediationConfigurations"
    ]
  }
}
PATTERN
}



resource "aws_cloudwatch_event_target" "cloudwatch_logs_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0
  rule  = aws_cloudwatch_event_rule.cloudwatch_logs_trigger[0].name
  arn   = module.event_bridge_tagger.lambda_function_arn
}

resource "aws_cloudwatch_event_target" "elasticache_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0
  rule  = aws_cloudwatch_event_rule.elasticache_trigger[0].name
  arn   = module.event_bridge_tagger.lambda_function_arn
}

resource "aws_cloudwatch_event_target" "ssm_parameter_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ssm_parameter_trigger[0].name
  arn   = module.event_bridge_tagger.lambda_function_arn
}

resource "aws_cloudwatch_event_target" "config_rule_trigger" {
  count = var.create_event_bridge_tagger ? 1 : 0
  rule  = aws_cloudwatch_event_rule.config_rule_trigger[0].name
  arn   = module.event_bridge_tagger.lambda_function_arn
}

module "event_bridge_schedule" {
  source = "terraform-aws-modules/eventbridge/aws"
  create = var.create_event_bridge_tagger

  bus_name = "event_bridge_tagger_schedule"

  attach_lambda_policy = true
  lambda_target_arns   = [module.event_bridge_tagger.lambda_function_arn]

  schedules = {
    event-bridge-tagger-cron = {
      description         = "Trigger for a Lambda"
      schedule_expression = var.schedule_expression
      timezone            = "America/Sao_Paulo"
      arn                 = module.event_bridge_tagger.lambda_function_arn
      input               = jsonencode({ "event_bridge_tagger_schedule": "schedule" }) # utilizado no script para distinguir o evento de schedule de outros.
    }
  }
}