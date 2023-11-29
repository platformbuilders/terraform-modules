## vpc
output "name" {
  value = aws_vpc._.tags["name"]
}

output "id" {
  value = aws_vpc._.id
}

output "cidr_block" {
  value = aws_vpc._.cidr_block
}

output "arn" {
  value = aws_vpc._.arn
}
