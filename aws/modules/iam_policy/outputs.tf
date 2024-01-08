output "arn" {
  description = "ARN da IAM role criada"
  value       = aws_iam_policy.this.arn
}

output "name" {
  description = "Nome da IAM role criada"
  value       = aws_iam_policy.this.name
}
