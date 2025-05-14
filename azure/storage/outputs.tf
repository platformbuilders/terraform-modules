output "storage_account_id" {
  description = "ID da Storage Account"
  value       = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  description = "Nome da Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "primary_blob_endpoint" {
  description = "Endpoint primário para blobs"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  description = "Endpoint primário para filas"
  value       = azurerm_storage_account.storage.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "Endpoint primário para tabelas"
  value       = azurerm_storage_account.storage.primary_table_endpoint
}

output "primary_file_endpoint" {
  description = "Endpoint primário para arquivos"
  value       = azurerm_storage_account.storage.primary_file_endpoint
}

output "primary_access_key" {
  description = "Chave de acesso primária"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Chave de acesso secundária"
  value       = azurerm_storage_account.storage.secondary_access_key
  sensitive   = true
}

output "container_ids" {
  description = "IDs dos containers criados"
  value       = { for k, v in azurerm_storage_container.containers : k => v.id }
}

output "queue_ids" {
  description = "IDs das filas criadas"
  value       = { for k, v in azurerm_storage_queue.queues : k => v.id }
}

output "table_ids" {
  description = "IDs das tabelas criadas"
  value       = { for k, v in azurerm_storage_table.tables : k => v.id }
}

output "file_share_ids" {
  description = "IDs dos file shares criados"
  value       = { for k, v in azurerm_storage_share.file_shares : k => v.id }
} 