variable "resource_group_name" {
  description = "Nome do Resource Group onde a subnet será criada"
  type        = string
}

variable "location" {
  description = "Região Azure onde os recursos serão criados"
  type        = string
}

variable "vnet_name" {
  description = "Nome da Virtual Network onde a subnet será criada"
  type        = string
}

variable "availability_zones" {
  description = "Lista de Availability Zones disponíveis na região"
  type        = list(string)
}

variable "public_subnets" {
  description = "Mapa de subnets públicas a serem criadas"
  type = map(object({
    name              = string
    cidr_block        = string
    az_index          = number
    service_endpoints = optional(list(string), [])
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
    enable_route_table = optional(bool, true)
  }))
  default = {}
}

variable "private_subnets" {
  description = "Mapa de subnets privadas a serem criadas"
  type = map(object({
    name              = string
    cidr_block        = string
    az_index          = number
    service_endpoints = optional(list(string), [])
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
    enable_route_table = optional(bool, true)
  }))
  default = {}
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
} 