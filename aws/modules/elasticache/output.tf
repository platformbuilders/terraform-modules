output "arn" {
  value = aws_elasticache_replication_group.default.arn
}

output "id" {
  value = aws_elasticache_replication_group.default.id
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.default.primary_endpoint_address
}
