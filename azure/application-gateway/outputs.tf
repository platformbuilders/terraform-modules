output "id" {
  description = "ID do Application Gateway"
  value       = azurerm_application_gateway.app_gateway.id
}

output "name" {
  description = "Nome do Application Gateway"
  value       = azurerm_application_gateway.app_gateway.name
}

output "public_ip_address" {
  description = "Endereço IP público do Application Gateway"
  value       = azurerm_application_gateway.app_gateway.frontend_ip_configuration[0].public_ip_address_id
}
