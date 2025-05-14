output "aks_identity_id" {
  description = "The id of the identity"
  value       = azurerm_user_assigned_identity._.id
}

output "aks_identity_principal_id" {
  description = "The principal id of the identity"
  value       = azurerm_user_assigned_identity._.principal_id
}