variable "resource_group_name" {
  description = "Nome do Resource Group onde o Redis será criado"
  type        = string
}

variable "location" {
  description = "Região Azure onde o Redis será criado"
  type        = string
}

variable "redis_name" {
  description = "Nome do Redis Cache"
  type        = string
}

variable "capacity" {
  description = "Tamanho do Redis Cache (0 = Basic, 1 = Standard, 2 = Premium)"
  type        = number
  default     = 1
  validation {
    condition     = contains([0, 1, 2], var.capacity)
    error_message = "O valor de capacity deve ser 0 (Basic), 1 (Standard) ou 2 (Premium)."
  }
}

variable "family" {
  description = "Família do Redis Cache (C = Basic/Standard, P = Premium)"
  type        = string
  default     = "C"
  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "O valor de family deve ser C (Basic/Standard) ou P (Premium)."
  }
}

variable "sku_name" {
  description = "SKU do Redis Cache (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "O valor de sku_name deve ser Basic, Standard ou Premium."
  }
}

variable "enable_non_ssl_port" {
  description = "Habilita porta não-SSL (6379)"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Versão mínima do TLS (1.0, 1.1, 1.2)"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "O valor de minimum_tls_version deve ser 1.0, 1.1 ou 1.2."
  }
}

variable "subnet_id" {
  description = "ID da subnet onde o Redis será criado (apenas para Premium)"
  type        = string
  default     = null
}

variable "private_static_ip_address" {
  description = "Endereço IP estático privado (apenas para Premium)"
  type        = string
  default     = null
}

variable "shard_count" {
  description = "Número de shards (apenas para Premium)"
  type        = number
  default     = null
}

variable "zones" {
  description = "Lista de zonas de disponibilidade (apenas para Premium)"
  type        = list(string)
  default     = null
}

variable "redis_configuration" {
  description = "Configurações adicionais do Redis"
  type = object({
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxmemory_policy                = optional(string)
    maxfragmentationmemory_reserved = optional(number)
    rdb_backup_enabled              = optional(bool)
    rdb_backup_frequency            = optional(number)
    rdb_backup_max_snapshot_count   = optional(number)
    rdb_storage_connection_string   = optional(string)
  })
  default = null
}

variable "firewall_rules" {
  description = "Regras de firewall para o Redis"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
} 