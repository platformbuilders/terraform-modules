resource "aws_security_group" "ssh" {
  name        = "vpnconnector-allow-ssh-sg"
  description = "Security group for SSH access"
  
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id


  vpc_security_group_ids = [aws_security_group.ssh.id]
  root_block_device {
    volume_size = var.disk_size
    volume_type = var.volume_type
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}
