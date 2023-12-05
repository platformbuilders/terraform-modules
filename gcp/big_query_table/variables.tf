variable "project_id" {
  description = "The project ID"
  default     = null
}

variable "dataset_id" {
  description = "The Dataset ID"
  default     = null
}

variable "table_id" {
  description = "Table/view name"
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance"
  default     = false
}

variable "description" {
  description = "The field description"
  default     = null
}

variable "query" {
  description = "If has query, a view will be created"
  default     = null
}

variable "use_legacy_sql" {
  description = "Specifies whether to use BigQuery's legacy SQL for this view. The default value is true. If set to false, the view will use BigQuery's standard SQL."
  default     = true
}

variable "time_partitioning_field" {
  description = "The field used to determine how to create a time-based partition. If time-based partitioning is enabled without this value, the table is partitioned based on the load time."
  default     = null
}

variable "time_partitioning_type" {
  description = "The supported types are DAY, HOUR, MONTH, and YEAR, which will generate one partition per day, hour, month, and year, respectively."
  default     = "DAY"
}
