resource "aws_mq_configuration" "_" {
  name           = format("%s-mq-broker-configuration", var.name)
  description    = "${var.name} MQ Configuration"
  engine_type    = var.engine_type
  engine_version = var.engine_version

  data = var.configuration
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
  security_groups    = [aws_security_group._.id]

  subnet_ids = var.subnet_ids

  user {
    username = var.username
    password = var.password
  }
}

resource "aws_security_group" "_" {
  name        = format("%s-mq-broker-sg", var.name)
  description = "Security Group for MQ -${var.name}- Broker."

  tags = merge(
    var.additional_tags,
    { Name = format("%s-mq-broker-sg", var.name) },
  )

  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type        = "egress"
  description = "Allow ALL Egress from the MQ Broker."
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group._.id
}

resource "aws_security_group_rule" "allow_sg" {
  count       = length(var.mq_broker_allowed_security_groups)
  type        = "ingress"
  description = "Allow all inbound connections from the specified Security Groups."
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"

  source_security_group_id = var.mq_broker_allowed_security_groups[count.index]

  security_group_id = aws_security_group._.id
}

resource "aws_security_group_rule" "allow_cidr_blocks" {
  count = length(var.mq_broker_allowed_cidr_blocks)

  type        = "ingress"
  description = "Allow all inbound connections from the specified CIDR blocks."

  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = var.mq_broker_allowed_cidr_blocks

  security_group_id = aws_security_group._.id
}
