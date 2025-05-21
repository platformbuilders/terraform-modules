resource "aws_elasticache_subnet_group" "this" {
  name       = var.name
  subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
  tags = var.additional_tags
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id = var.cluster_id
  description          = var.cluster_id

  node_type            = var.node_type
  port                 = var.port
  parameter_group_name = var.parameter_group_name

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window

  subnet_group_name = aws_elasticache_subnet_group.this.name

  automatic_failover_enabled = var.automatic_failover_enabled
  apply_immediately          = var.apply_immediately

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  dynamic "log_delivery_configuration" {
    for_each = var.enable_engine_logs ? [1] : []
    content {
      destination      = var.log_destination
      destination_type = var.log_destination_type
      log_format       = "json"
      log_type         = "engine-log"
    }

  }
}

resource "aws_elasticache_cluster" "this" {
  count                = var.num_cache_nodes
  cluster_id           = "${var.cluster_id}-${count.index}"
  replication_group_id = aws_elasticache_replication_group.default.id
}
