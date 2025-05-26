output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.rds_scheduler_lambda_role.arn
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = aws_iam_role.rds_scheduler_lambda_role.name
} 