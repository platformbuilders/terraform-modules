locals {
  monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : var.monitoring_role_arn

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${try(random_id.snapshot_identifier.hex, "")}"

  identifier = var.identifier

  monitoring_role_name = var.monitoring_role_name

  is_replica = var.replicate_source_db != null
}

data "aws_partition" "current" {}

resource "random_id" "snapshot_identifier" {
  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

resource "aws_db_subnet_group" "this" {
  name       = var.identifier
  subnet_ids = var.vpc_db_subnet_ids

  tags = {
    Name = format("%s-%s", "db-group", var.identifier)
  }
}

resource "aws_db_instance" "this" {
  identifier = local.identifier

  engine                   = local.is_replica ? null : var.engine
  engine_version           = var.engine_version
  engine_lifecycle_support = var.engine_lifecycle_support
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  storage_type             = var.storage_type
  storage_encrypted        = var.storage_encrypted
  kms_key_id               = var.kms_key_id
  license_model            = var.license_model

  db_name                             = var.db_name
  username                            = !local.is_replica ? var.username : null
  password                            = !local.is_replica && var.manage_master_user_password ? null : var.password
  port                                = var.port
  domain                              = var.domain
  domain_auth_secret_arn              = var.domain_auth_secret_arn
  domain_dns_ips                      = var.domain_dns_ips
  domain_fqdn                         = var.domain_fqdn
  domain_iam_role_name                = var.domain_iam_role_name
  domain_ou                           = var.domain_ou
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile
  manage_master_user_password         = !local.is_replica && var.manage_master_user_password ? var.manage_master_user_password : null
  master_user_secret_kms_key_id       = !local.is_replica && var.manage_master_user_password ? var.master_user_secret_kms_key_id : null

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = var.parameter_group_name
  option_group_name      = var.option_group_name
  network_type           = var.network_type

  availability_zone    = var.availability_zone
  multi_az             = var.multi_az
  iops                 = var.iops
  storage_throughput   = var.storage_throughput
  publicly_accessible  = var.publicly_accessible
  ca_cert_identifier   = var.ca_cert_identifier
  dedicated_log_volume = var.dedicated_log_volume

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = local.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_interval > 0 ? local.monitoring_role_arn : null

  character_set_name       = var.character_set_name
  nchar_character_set_name = var.nchar_character_set_name
  timezone                 = var.timezone

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = "mysql"
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }

  tags = merge(var.tags, var.db_instance_tags)

  depends_on = []

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

}

data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name                 = local.monitoring_role_name
  assume_role_policy   = data.aws_iam_policy_document.enhanced_monitoring.json
  description          = var.monitoring_role_description
  permissions_boundary = var.monitoring_role_permissions_boundary

  tags = merge(
    {
      "Name" = format("%s", var.monitoring_role_name)
    },
    var.tags,
  )
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.manage_master_user_password && var.manage_master_user_password_rotation ? 1 : 0

  secret_id          = aws_db_instance.this.master_user_secret[0].secret_arn
  rotate_immediately = var.master_user_password_rotate_immediately

  rotation_rules {
    automatically_after_days = var.master_user_password_rotation_automatically_after_days
    duration                 = var.master_user_password_rotation_duration
    schedule_expression      = var.master_user_password_rotation_schedule_expression
  }
}
