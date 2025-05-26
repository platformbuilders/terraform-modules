locals {
  lambda_zip_path = "${path.module}/lambda/lambda_function.zip"
}

# TODO: Executar o script de build.sh para gerar o lambda_function.zip
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
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.rds_scheduler.function_name}"
  retention_in_days = 14
} 