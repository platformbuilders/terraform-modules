# lambda https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest

locals {
  function_name        = "${var.function_name}_function"
  function_source_code = "../../src/${local.function_name}.py"
  function_source_zip  = "../../src/${local.function_name}.zip"
  name                 = "${var.function_name}"
}

# executa comado na maquina local
# gera/atualiza zip a partir da function ".py"
resource "null_resource" "zip_function" {
  provisioner "local-exec" {
    command = "zip ${local.function_source_zip} ${local.function_source_code} ${var.files_for_zip}"
  }
  triggers = {
    always_run = timestamp()
  }
}

data "aws_caller_identity" "current" {}

data "archive_file" "my_function" {
  type        = "zip"
  source_file = local.function_source_zip
  output_path = "../../src/output/${local.function_name}.zip"
  depends_on  = [null_resource.zip_function]
}

resource "aws_s3_bucket_versioning" "version_s3_file" {
  bucket = aws_s3_bucket.builds.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "builds" {
  bucket = "${var.function_name}-${var.aws_s3_bucket_name}-function"
}

resource "aws_s3_object" "my_function" {
  bucket = aws_s3_bucket_versioning.version_s3_file.id
  key    = "${local.function_name}.zip"
  source = data.archive_file.my_function.source_file
}


##################################
# Função de Lambda da AWS, Principal
##################################

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = local.name
  description            = "Lambda de criação de tags para recursos de ${var.function_name}"
  handler                = "__init__.lambda_handler"
  runtime                = "python3.10"
  ephemeral_storage_size = 10240
  architectures          = ["x86_64"]
  publish                = true
  create_function        = true
  create_layer           = false

  allowed_triggers = {
    triggertimer = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.trigger_rule.arn
    }
  }
  create_current_version_allowed_triggers = true

  environment_variables = var.environment_variables


  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Sid": "VisualEditor0",
                  "Effect": "Allow",
                  "Action": [
                      "ec2:*",
                      "elasticloadbalancing:*",
                      "rds:*",
                      "eks:*",
                      "config:*",
                      "autoscaling:*"
                  ],
                  "Resource": "*"
              },
              {
                  "Sid": "VisualEditor2",
                  "Effect": "Allow",
                  "Action": [
                      "logs:CreateLogStream",
                      "logs:PutLogEvents",
                      "logs:CreateLogGroup"
                  ],
                  "Resource": "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.name}:*"
              }
          ]
      }
    EOT
  ]
  number_of_policy_jsons = 1
  assume_role_policy_statements = {
    account_root = {
      effect  = "Allow",
      actions = ["sts:AssumeRole"],
      principals = {
        account_principal = {
          type        = "Service",
          identifiers = ["lambda.amazonaws.com"]
        }
      }
      condition = {
        stringequals_condition = {
          test     = "ArnLike"
          variable = "AWS:SourceArn"
          values   = ["arn:aws:events:eu-east-1:${data.aws_caller_identity.current.account_id}:rule/${local.function_name}"]
        }
      }
    }
  }

  create_package      = false
  s3_object_tags_only = true
  s3_existing_package = {
    bucket     = aws_s3_bucket_versioning.version_s3_file.id
    key        = aws_s3_object.my_function.id
    version_id = aws_s3_object.my_function.version_id
  }
  timeout = 900
}


##################################
# Cloudwatch Events (EventBridge)
##################################


resource "aws_cloudwatch_event_rule" "trigger_rule" {
  name                = local.name
  description         = "Faz o tagueamento baseado nas intancias de 15 em 15 minutos"
  schedule_expression = "rate(15 minutes)"
  is_enabled          = true

}

resource "aws_cloudwatch_event_target" "scan_ami_lambda_function" {
  rule = aws_cloudwatch_event_rule.trigger_rule.name
  arn  = module.lambda_function.lambda_function_arn
}

