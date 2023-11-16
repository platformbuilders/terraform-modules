variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "name" {
  type        = string
  description = "Rule name"
}

variable "region" {
  type        = string
  description = "Region of BigQuery"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "tier" {
  type        = string
  description = "Environment tier"
}

variable "kms_key" {
  type        = string
  description = "KMS key"
}

variable "dataset_owners" {
  type = list(string)
  # Exemplo: ["user:joao.assis@platformbuilders.io", "group:security-group@platformbuilders.io"]
}

variable "dataset_readers" {
  type = list(string)
  # Exemplo: ["user:joao.assis@platformbuilders.io", "group:security-group@platformbuilders.io"]
}
