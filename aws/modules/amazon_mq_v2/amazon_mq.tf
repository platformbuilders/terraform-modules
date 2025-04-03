resource "aws_mq_configuration" "_" {
  name           = format("%s-mq-broker-configuration", var.name)
  description    = "${var.name} MQ Configuration"
  engine_type    = var.engine_type
  engine_version = var.engine_version

  data = var.configuration

  tags = var.additional_tags
}

resource "aws_mq_broker" "_" {
  broker_name = format("%s-mq-broker", var.name)

  configuration {
    id       = aws_mq_configuration._.id
    revision = aws_mq_configuration._.latest_revision
  }

  engine_type        = var.engine_type
  engine_version     = var.engine_version
  storage_type       = var.storage_type
  host_instance_type = var.host_instance_type
  deployment_mode    = var.deployment_mode
  security_groups    = [aws_security_group.amazon_mq_sg.id]

  subnet_ids = var.subnet_ids

  tags = var.additional_tags

  user {
    username = var.username
    password = var.password
  }
}
