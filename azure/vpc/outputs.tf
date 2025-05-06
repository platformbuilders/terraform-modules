output "vnet_id" {
  description = "ID da Virtual Network criada"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Nome da Virtual Network criada"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_cidr_block" {
  description = "CIDR block principal da VPC"
  value       = var.cidr_block
}

output "vnet_secondary_cidr_blocks" {
  description = "Lista de CIDR blocks secundários da VPC"
  value       = var.secondary_cidr_blocks
}

output "private_dns_zone_id" {
  description = "ID da zona DNS privada criada"
  value       = var.enable_dns_hostnames ? azurerm_private_dns_zone.dns_zone[0].id : null
}

output "private_dns_zone_name" {
  description = "Nome da zona DNS privada criada"
  value       = var.enable_dns_hostnames ? azurerm_private_dns_zone.dns_zone[0].name : null
}

output "flow_log_storage_account_id" {
  description = "ID da conta de armazenamento dos Flow Logs"
  value       = var.enable_flow_log ? azurerm_storage_account.flow_log_storage[0].id : null
}

output "flow_log_workspace_id" {
  description = "ID do workspace do Log Analytics para Flow Logs"
  value       = var.enable_flow_log ? azurerm_log_analytics_workspace.flow_log_workspace[0].id : null
}

output "subnet_ids" {
  description = "Mapa de IDs das subnets criadas"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "nsg_ids" {
  description = "Mapa de IDs dos Network Security Groups criados"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
} 