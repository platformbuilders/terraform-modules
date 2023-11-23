output "user_name" {
  description = "Nome do IAM user criado"
  value       = aws_iam_user.this.name
}

output "user_arn" {
  description = "ARN do IAM user criado"
  value       = aws_iam_user.this.arn
}
