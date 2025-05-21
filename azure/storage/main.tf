resource "azurerm_storage_account" "storage" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  access_tier                   = var.access_tier
  min_tls_version               = var.min_tls_version
  public_network_access_enabled = var.allow_blob_public_access
  https_traffic_only_enabled    = var.enable_https_traffic_only
  tags                          = var.tags

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      identity
    ]
  }
}

# Aguarda a Storage Account estar completamente provisionada
resource "time_sleep" "wait_for_storage_account" {
  depends_on      = [azurerm_storage_account.storage]
  create_duration = "30s"
}

resource "azurerm_storage_container" "containers" {
  for_each   = { for container in var.containers : container.name => container }
  depends_on = [time_sleep.wait_for_storage_account]

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = each.value.access_type
}

resource "azurerm_storage_queue" "queues" {
  for_each   = toset(var.queues)
  depends_on = [time_sleep.wait_for_storage_account]

  name                 = each.value
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_table" "tables" {
  for_each   = toset(var.tables)
  depends_on = [time_sleep.wait_for_storage_account]

  name                 = each.value
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_share" "file_shares" {
  for_each   = { for share in var.file_shares : share.name => share }
  depends_on = [time_sleep.wait_for_storage_account]

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage.name
  quota                = each.value.quota_in_gb
  access_tier          = each.value.access_tier
  enabled_protocol     = each.value.enabled_protocol
}

resource "azurerm_storage_management_policy" "lifecycle_rules" {
  count      = length(var.lifecycle_rules) > 0 ? 1 : 0
  depends_on = [time_sleep.wait_for_storage_account]

  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        prefix_match = [rule.value.prefix]
        blob_types   = ["blockBlob"]
      }

      actions {
        base_blob {}
      }
    }
  }
} 