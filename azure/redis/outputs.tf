output "redis_id" {
  description = "ID do Redis Cache"
  value       = azurerm_redis_cache.redis.id
}

output "redis_name" {
  description = "Nome do Redis Cache"
  value       = azurerm_redis_cache.redis.name
}

output "redis_hostname" {
  description = "Hostname do Redis Cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_ssl_port" {
  description = "Porta SSL do Redis Cache"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "redis_primary_access_key" {
  description = "Chave de acesso primária do Redis Cache"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "redis_secondary_access_key" {
  description = "Chave de acesso secundária do Redis Cache"
  value       = azurerm_redis_cache.redis.secondary_access_key
  sensitive   = true
}

output "redis_connection_string" {
  description = "String de conexão do Redis Cache"
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
} 