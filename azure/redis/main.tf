locals {
  is_premium = var.sku_name == "Premium"
}

resource "azurerm_redis_cache" "redis" {
  name                      = var.redis_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  capacity                  = var.capacity
  family                    = var.family
  sku_name                  = var.sku_name
  non_ssl_port_enabled      = var.enable_non_ssl_port
  minimum_tls_version       = var.minimum_tls_version
  subnet_id                 = local.is_premium ? var.subnet_id : null
  private_static_ip_address = local.is_premium ? var.private_static_ip_address : null
  shard_count               = local.is_premium ? var.shard_count : null
  zones                     = local.is_premium ? var.zones : null
  tags                      = var.tags

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      maxmemory_reserved              = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                 = redis_configuration.value.maxmemory_delta
      maxmemory_policy                = redis_configuration.value.maxmemory_policy
      maxfragmentationmemory_reserved = redis_configuration.value.maxfragmentationmemory_reserved
      rdb_backup_enabled              = redis_configuration.value.rdb_backup_enabled
      rdb_backup_frequency            = redis_configuration.value.rdb_backup_frequency
      rdb_backup_max_snapshot_count   = redis_configuration.value.rdb_backup_max_snapshot_count
      rdb_storage_connection_string   = redis_configuration.value.rdb_storage_connection_string
    }
  }
}

resource "azurerm_redis_firewall_rule" "firewall_rules" {
  for_each = var.firewall_rules

  name                = each.key
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}
 