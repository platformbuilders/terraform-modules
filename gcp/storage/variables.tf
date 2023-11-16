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

variable "kms_key_name" {
  type        = string
  description = "KMS Key name"
}