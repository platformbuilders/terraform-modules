## EKS vpc 
resource "aws_vpc" "_" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.additional_tags,
    {
      name = "${var.name}-vpc"
    },
  )
}
