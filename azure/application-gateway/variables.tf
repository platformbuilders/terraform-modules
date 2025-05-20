variable "app_gateway_name" {
  description = "Nome do Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização do recurso"
  type        = string
}

variable "sku_name" {
  description = "Nome do SKU do Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "Tier do SKU do Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "capacity" {
  description = "Capacidade do Application Gateway"
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "ID da subnet onde o Application Gateway será implantado"
  type        = string
}

variable "frontend_ports" {
  description = "Lista de portas frontend"
  type = list(object({
    name = string
    port = number
  }))
  default = [
    {
      name = "port_80"
      port = 80
    }
  ]
}

variable "backend_address_pools" {
  description = "Lista de pools de endereços backend"
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "Lista de configurações HTTP backend"
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    port                  = number
    protocol              = string
    request_timeout       = number
    probe_name            = string
  }))
}

variable "http_listeners" {
  description = "Lista de listeners HTTP"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = optional(string)
  }))
}

variable "request_routing_rules" {
  description = "Lista de regras de roteamento"
  type = list(object({
    name                       = string
    priority                   = number
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    redirect_to_ssl            = bool
  }))
}

variable "probes" {
  description = "Lista de probes de saúde"
  type = list(object({
    name                = string
    protocol            = string
    path                = string
    host                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
  }))
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}

variable "ssl_certificates" {
  description = "Lista de certificados SSL"
  type = list(object({
    name = string
    data = string
    password = string
  }))
}
