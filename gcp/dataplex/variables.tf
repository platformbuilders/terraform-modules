variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "name" {
  type        = string
  description = "Subnet name"
}

variable "region" {
  type        = string
  description = "Region of subnet"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "discovery_spec_enabled" {
  type        = bool
  description = "Whether discovery is enabled."
  default     = true
}

variable "discovery_spec_schedule" {
  type        = string
  description = "Cron schedule for running discovery periodically."
  default     = "0 12 * * *"
}

variable "zones" {
  type = list(object({
    name               = string,
    type               = string,
    resource_spec_name = string,
    resource_spec_type = string,
    create_inputs      = bool,
    inputs_storage     = string
  }))
  description = "List of zone names"
}
