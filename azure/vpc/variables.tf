variable "resource_group_name" {
  description = "Nome do Resource Group onde a VPC será criada"
  type        = string
}

variable "location" {
  description = "Região Azure onde os recursos serão criados"
  type        = string
}

variable "vnet_name" {
  description = "Nome da Virtual Network"
  type        = string
}

variable "cidr_block" {
  description = "Espaço de endereçamento da VPC (CIDR)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_cidr_blocks" {
  description = "Lista de blocos CIDR secundários para a VPC"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Habilita suporte a DNS hostnames na VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Habilita suporte a DNS na VPC"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Habilita Flow Logs para a VPC"
  type        = bool
  default     = false
}

variable "flow_log_retention_in_days" {
  description = "Número de dias para retenção dos Flow Logs"
  type        = number
  default     = 30
}

variable "flow_log_traffic_type" {
  description = "Tipo de tráfego a ser registrado nos Flow Logs (ACCEPT, REJECT, ALL)"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "O tipo de tráfego deve ser ACCEPT, REJECT ou ALL."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
} 