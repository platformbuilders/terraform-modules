## vpc
output "private-names" {
  value = [for i in range(length(aws_subnet.private)) : aws_subnet.private[i].tags["Name"]]
}

output "public-names" {
  value = [for i in range(length(aws_subnet.public)) : aws_subnet.public[i].tags["Name"]]
}

output "private-ids" {
  value = [for i in range(length(aws_subnet.private)) : aws_subnet.private[i].id]
}

output "private-db-ids" {
  value = [for i in range(length(aws_subnet.private_db)) : aws_subnet.private_db[i].id]
}

output "public-ids" {
  value = [for i in range(length(aws_subnet.public)) : aws_subnet.public[i].id]
}
