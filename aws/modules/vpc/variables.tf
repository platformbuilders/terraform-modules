variable "name" {
  description = "EKS Regional unique cluster name"
  type        = string
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
}

variable "cidr" {
  description = "VPC IP range"
  type        = string
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Assign generated IPv6 CIDR block for VPC"
  default     = null
  type        = bool
}
