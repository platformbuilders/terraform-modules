output "subnet_ids" {
  description = "Mapa de IDs das subnets criadas"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "nsg_ids" {
  description = "Mapa de IDs dos Network Security Groups criados"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway criado para as subnets privadas"
  value       = length(var.private_subnets) > 0 ? azurerm_nat_gateway.nat_gateway[0].id : null
}

output "nat_gateway_public_ip" {
  description = "Endereço IP público do NAT Gateway"
  value       = length(var.private_subnets) > 0 ? azurerm_public_ip.nat_gateway_ip[0].ip_address : null
}

# output "private_route_table_id" {
#   description = "ID da Route Table criada para as subnets privadas"
#   value       = length(var.private_subnets) > 0 ? azurerm_route_table.private_route_table[0].id : null
# }

output "public_subnet_ids" {
  description = "Mapa de IDs das subnets públicas"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id if contains(keys(var.public_subnets), k) }
}

output "private_subnet_ids" {
  description = "Mapa de IDs das subnets privadas"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id if contains(keys(var.private_subnets), k) }
} 