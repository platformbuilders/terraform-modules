variable "user_name" {
  description = "Nome do IAM user"
  type        = string
}

variable "path" {
  description = "Caminho para o IAM user"
  type        = string
  default     = "/"
}

variable "managed_policy_arns" {
  description = "ARNs das políticas gerenciadas para associar ao usuário"
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
  description = "Tags para associar ao IAM user"
  type        = map(string)
  default     = {}
}
