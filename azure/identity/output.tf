output "identity_id" {
  description = "This is the id for the user assigned identity."
  value       = azurerm_user_assigned_identity._.id
}

output "client_id" {
  description = "This is the client id for the user assigned identity."
  value       = azurerm_user_assigned_identity._.client_id
}

output "principal_id" {
  description = "This is the principal id for the user assigned identity."
  value       = azurerm_user_assigned_identity._.principal_id
}

output "resource_name" {
  description = "The name of the User Assigned Identity that was created."
  value       = azurerm_user_assigned_identity._.name
}

output "tenant_id" {
  description = "The ID of the Tenant which the Identity belongs to."
  value       = azurerm_user_assigned_identity._.tenant_id
}