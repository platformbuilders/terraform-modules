variable "resource_group_name" {
  description = "Nome do Resource Group onde a Storage Account será criada"
  type        = string
}

variable "location" {
  description = "Região Azure onde a Storage Account será criada"
  type        = string
}

variable "storage_account_name" {
  description = "Nome da Storage Account"
  type        = string
}

variable "account_tier" {
  description = "Tier da Storage Account (Standard ou Premium)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "O valor de account_tier deve ser Standard ou Premium."
  }
}

variable "account_replication_type" {
  description = "Tipo de replicação (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "O valor de account_replication_type deve ser LRS, GRS, RAGRS, ZRS, GZRS ou RAGZRS."
  }
}

variable "access_tier" {
  description = "Tier de acesso (Hot ou Cool)"
  type        = string
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "O valor de access_tier deve ser Hot ou Cool."
  }
}

variable "enable_https_traffic_only" {
  description = "Força o uso de HTTPS para todas as operações"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Versão mínima do TLS (TLS1_0, TLS1_1, TLS1_2)"
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "O valor de min_tls_version deve ser TLS1_0, TLS1_1 ou TLS1_2."
  }
}

variable "allow_blob_public_access" {
  description = "Permite acesso público aos blobs"
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Regras de rede para a Storage Account"
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

variable "containers" {
  description = "Lista de containers a serem criados"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "queues" {
  description = "Lista de filas a serem criadas"
  type        = list(string)
  default     = []
}

variable "tables" {
  description = "Lista de tabelas a serem criadas"
  type        = list(string)
  default     = []
}

variable "file_shares" {
  description = "Lista de file shares a serem criadas"
  type = list(object({
    name             = string
    quota_in_gb      = number
    access_tier      = string
    enabled_protocol = string
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "Regras de lifecycle para os blobs"
  type = list(object({
    name                       = string
    enabled                    = bool
    prefix                     = string
    tier_to_cool_after_days    = optional(number)
    tier_to_archive_after_days = optional(number)
    delete_after_days          = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
} 