locals {
  lambda_zip_path = "${path.module}/lambda/lambda_function.zip"
}

# Create a data source that depends on the build script
data "external" "lambda_build" {
  program = ["bash", "${path.module}/lambda/lambda/build.sh"]
  working_dir = "${path.module}/lambda/lambda"
}

resource "aws_lambda_function" "rds_scheduler" {
  filename         = local.lambda_zip_path
  function_name    = "rds-scheduler"
  role            = var.lambda_role_arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 128

  source_code_hash = filebase64sha256(local.lambda_zip_path)

  environment {
    variables = {
      TZ = "America/Sao_Paulo"
    }
  }

  depends_on = [data.external.lambda_build]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.rds_scheduler.function_name}"
  retention_in_days = 14
} 