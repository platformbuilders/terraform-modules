variable "name" {
  description = "Nome da IAM role"
  type        = string
}

variable "description" {
  description = "Descrição da IAM role"
  type        = string
}

variable "path" {
  description = "Path da IAM role"
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "ARN da permission boundary"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "policy que determina quem pode assumir a role"
  type        = string
}

variable "managed_policy_arns" {
  description = "Lista de ARNs de managed policies para associar a role"
  type        = list(string)
  default     = null
}

variable "inline_policies" {
  description = "Map de inline policy para associar a role"
  type        = map(object({
    policy = string
  }))
  default = null
}

variable "tags" {
  description = "Tags para associar a IAM role"
  type        = map(string)
  default     = {}
}
