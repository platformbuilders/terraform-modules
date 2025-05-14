locals {
  # Combina o CIDR principal com os secundários
  all_cidr_blocks = concat([var.cidr_block], var.secondary_cidr_blocks)
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = local.all_cidr_blocks
  dns_servers         = var.enable_dns_support ? ["168.63.129.16"] : [] # DNS do Azure
  tags                = var.tags
}

# Configuração de DNS
resource "azurerm_private_dns_zone" "dns_zone" {
  count = var.enable_dns_hostnames ? 1 : 0

  name                = "${var.vnet_name}.local"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  count = var.enable_dns_hostnames ? 1 : 0

  name                  = "${var.vnet_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Configuração de Flow Logs
resource "azurerm_storage_account" "flow_log_storage" {
  count = var.enable_flow_log ? 1 : 0

  name                     = replace("${var.vnet_name}flowlogs", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_network_watcher_flow_log" "flow_log" {
  count = var.enable_flow_log ? 1 : 0

  name                      = "${var.vnet_name}-flow-logs"
  network_watcher_name      = "NetworkWatcher_${var.location}"
  resource_group_name       = "NetworkWatcherRG"
  network_security_group_id = azurerm_virtual_network.vnet.id
  storage_account_id        = azurerm_storage_account.flow_log_storage[0].id
  enabled                   = true
  retention_policy {
    enabled = true
    days    = var.flow_log_retention_in_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.flow_log_workspace[0].workspace_id
    workspace_region      = var.location
    workspace_resource_id = azurerm_log_analytics_workspace.flow_log_workspace[0].id
    interval_in_minutes   = 10
  }
}

resource "azurerm_log_analytics_workspace" "flow_log_workspace" {
  count = var.enable_flow_log ? 1 : 0

  name                = "${var.vnet_name}-flow-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.flow_log_retention_in_days
  tags                = var.tags
}