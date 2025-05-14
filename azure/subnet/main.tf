locals {
  all_subnets = merge(
    { for k, v in var.public_subnets : k => merge(v, { is_public = true }) },
    { for k, v in var.private_subnets : k => merge(v, { is_public = false }) }
  )
}

resource "azurerm_subnet" "subnets" {
  for_each = local.all_subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [each.value.cidr_block]
  service_endpoints    = each.value.service_endpoints
}

resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.all_subnets : subnet.name => subnet
    if length(subnet.nsg_rules) > 0
  }

  name                = "nsg-${each.value.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = merge(var.tags, {
    Type = each.value.is_public ? "Public" : "Private"
    AZ   = var.availability_zones[each.value.az_index]
  })

  dynamic "security_rule" {
    for_each = each.value.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = {
    for subnet in local.all_subnets : subnet.name => subnet
    if length(subnet.nsg_rules) > 0
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Cria um NAT Gateway para as subnets privadas
resource "azurerm_public_ip" "nat_gateway_ip" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  name                = "nat-gateway-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones
  tags                = var.tags
}

resource "azurerm_nat_gateway" "nat_gateway" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  name                = "nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  zones               = var.availability_zones
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_ip_association" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway_ip[0].id
}

# Cria uma Route Table para as subnets públicas
resource "azurerm_route_table" "public_route_table" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  name                = "public-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_route_table_association" "public_route_table_association" {
  for_each = {
    for subnet_key, subnet in var.public_subnets :
    subnet_key => subnet if lookup(subnet, "enable_route_table", true)
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.public_route_table[0].id
}

# Cria uma Route Table para as subnets privadas
resource "azurerm_route_table" "private_route_table" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  name                = "private-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.nat_gateway_ip[0].ip_address
  }
}

resource "azurerm_subnet_route_table_association" "private_route_table_association" {
  for_each = {
    for subnet_key, subnet in var.private_subnets :
    subnet_key => subnet if lookup(subnet, "enable_route_table", true)
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.private_route_table[0].id
}

# Associação do NAT Gateway com as subnets privadas
resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each = var.private_subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
} 