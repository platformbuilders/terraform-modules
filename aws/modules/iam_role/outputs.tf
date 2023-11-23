output "role_arn" {
  description = "ARN da IAM role criada"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM role criada"
  value       = aws_iam_role.this.name
}
