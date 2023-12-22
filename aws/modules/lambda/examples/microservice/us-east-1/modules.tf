locals {
  environment_variables = {
    AWS_ACCOUNTS_JSON = jsonencode({
      "Accounts" : [
        {
          "AccountName" : "${var.account_name}",
          "AccountId" : "${data.aws_caller_identity.current.account_id}",
          "RoleARN" : "arn",
          "region" : "${var.region}",
          "Sufix_Account" : "",
          "board" : ""
          "account_dictionary" : ""
        }
      ]
    })

  }
}

data "aws_caller_identity" "current" {}


module "lambda_eks" {
  source                = "../../modules/lambda"
  aws_s3_bucket_name    = var.aws_s3_bucket_name
  environment_variables = local.environment_variables
  function_name         = "eks"
  files_for_zip = "../../src/__init__.py ../../src/mineracao.py ../../src/ec2_function.py ../../src/logs_function.py ../../src/validations.py ../../src/application-domain.json"
}
