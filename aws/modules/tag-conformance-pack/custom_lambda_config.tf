module "lambda_custom_config_required_tags" {
  source          = "terraform-aws-modules/lambda/aws"
  create_function = true

  function_name = "lambda_custom_config_required_tags"
  description   = "lambda para o aws config custom rule. Avalia se os recursos verificads estao em compliance ou não com as tags definidas no config."
  handler       = "${trimsuffix(var.custom_lambda_script, ".py")}.lambda_handler"
  runtime       = "python3.10"
  create        = true

  source_path                        = "${var.script_path}/${var.custom_lambda_script}"
  attach_create_log_group_permission = true
  architectures                      = ["x86_64"]
  cloudwatch_logs_retention_in_days = 1
  create_role                        = true
  role_name                          = "lambda_custom_config_required_tags"
  publish                            = true

  attach_policy = true

  policy = "arn:aws:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"

  assume_role_policy_statements = {
    assumeRole = {
      effect     = "Allow",
      actions    = ["sts:AssumeRole"],
      principals = {
        account_principal = {
          type        = "Service",
          identifiers = ["lambda.amazonaws.com"]
        }
      }
    }
  }
  allowed_triggers = {
    Config = {
      principal  = "config.amazonaws.com"
      source_account = data.aws_caller_identity.current.account_id
    }
  }

  timeout = 600

}
