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

variable "versioning" {
  type        = bool
  description = "Configure storage versioning"
  default     = false
}

variable "lifecycle_rules" {
  type = list(object({
    condition = object({
      age                        = optional(number)
      days_since_custom_time     = optional(number)
      days_since_noncurrent_time = optional(number)
      matches_prefix             = optional(list(string))
      matches_storage_class      = optional(list(string))
      matches_suffix            = optional(list(string))
      num_newer_versions        = optional(number)
      with_state               = optional(string)
    })
    action = object({
      type = string
    })
  }))
  description = "List of lifecycle rules for the bucket"
  default     = []
}