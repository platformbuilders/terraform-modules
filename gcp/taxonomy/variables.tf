variable "project_id" {
  description = "ID do projeto"
  type        = string
}

variable "name" {
  description = "Nome do taxonomy"
  type        = string
}

variable "description" {
  description = "Descrição do taxonomy"
  type        = string
}

variable "activated_policy_types" {
  description = "Tipos de política ativados"
  type        = list(string)
  default     = ["FINE_GRAINED_ACCESS_CONTROL"]
}

variable "policy_tags" {
  description = "Mapa de políticas de tags"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}
