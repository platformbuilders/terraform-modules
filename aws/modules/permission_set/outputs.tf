output "permission_set_arn" {
  description = "ARN do Permission Set do AWS SSO criado"
  value       = aws_ssoadmin_permission_set.this.arn
}

