variable "name" {
  description = "EKS Regional unique cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
}

variable "private_subnets" {
  description = "VPC IP range"
  type        = list(string)
}

variable "private_subnets_db" {
  description = "VPC IP range Private Database"
  type        = list(string)  
}

variable "public_subnets" {
  description = "VPC IP range"
  type        = list(string)
}

variable "isPublic" {
  description = "Is subnet public? (Have a public IP)"
  type        = bool
  default     = false
}

variable "azs" {
  type        = list(string)
  description = "The az"
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
