resource "aws_elasticache_subnet_group" "this" {
  name       = var.name
  subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = var.port
  num_cache_nodes      = var.num_cache_nodes
  security_group_ids   = var.security_group_ids
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  parameter_group_name = var.parameter_group_name
  tags = {
    Name = var.name
  }
}
