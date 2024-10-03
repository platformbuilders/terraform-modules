variable "name" {
  description = "Redis instance name"
}

variable "tier" {
  description = "Redis tier"
  default     = "BASIC"
}

variable "memory" {
  description = "memory size"
}

variable "region" {
  description = "redis region location"
  default     = "southamerica-east1-c"
}
variable "transit_encryption_mode" {
  description = "Use TLS or not"
}

variable "display_name" {
  description = "Redis display name"
}

variable "authorized_network" {
  description = "VPC authorized to access Redis"
}