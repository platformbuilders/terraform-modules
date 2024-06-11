# Postgres Security Group
resource "aws_security_group" "amazon_mq_sg" {
  name        = "${var.name}-amazonmq-allow-access"
  description = "Amazon MQ security group"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow amazonmq access from within VPC"
    from_port        = 5671
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Allow https access from within VPC for RabbitMQ console"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    var.additional_tags,
    {
    Name = "${var.name}-amazonmq-allow-access"
    },
  )  
} 