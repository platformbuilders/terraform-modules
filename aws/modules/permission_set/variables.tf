variable "permission_set_name" {
  description = "Nome do Permission Set do AWS SSO"
  type        = string
}

variable "instance_arn" {
  description = "ARN da instância do AWS SSO"
  type        = string
}

variable "description" {
  description = "Descrição do Permission Set do AWS SSO"
  type        = string
  default     = ""
}

variable "session_duration" {
  description = "Tempo de sessão para o Permission Set"
  type        = string
  default     = "PT1H"
}

variable "managed_policy_arns" {
  description = "Lista de ARNs de managed policies para associar ao Permission Set"
  type        = list(string)
  default     = null
}

variable "inline_policy" {
  description = "A política inline JSON para aplicar ao Permission Set"
  type        = string
  default     = null
}

variable "permission_boundary" {
  description = "Nome da boundary policy para aplicar ao Permission Set"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags para associar ao Permission Set do AWS SSO"
  type        = map(string)
  default     = {}
}
