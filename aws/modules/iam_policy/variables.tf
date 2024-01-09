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

variable "policy" {
  description = "Map de inline policy para associar a role"
  type        = string
}

variable "tags" {
  description = "Tags para associar a IAM role"
  type        = map(string)
  default     = {}
}
