variable "name" {
  type        = string
  description = "The used in resources, can be Org or Project Name"
}

variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "postgres_version" {
  description = "The engine version of the database, e.g. `POSTGRES_17`. See https://cloud.google.com/sql/docs/db-versions for supported versions."
  type        = string
}

variable "instance_tier" {
  description = "Machine type for this environment"
  type        = string
  # Choose a machine type and define it here as in the example: db-custom-2-7680
}

variable "edition" {
  description = "Edition database"
  type        = string
}

variable "psc_enabled" {
  description = "Set to true to enable private IP"
  type        = string
}

variable "backup_configuration" {
  description = "Set to true to enable backup"
  type        = string
}

variable "start_time" {
  description = "Set the time to start the backup"
  type        = string
}

variable "availability_type" {
  description = "Set the availability type of the database" # ZONAL or REGIONAL
  type        = string
}