## EKS vpc 
resource "aws_vpc" "_" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    var.additional_tags,
    {
      name = "${var.name}-vpc"
    },
  )
}
