variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "name" {
  type        = string
  description = "VPC name"
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = true
  description = "Whether or not to create subnetwork for each region"
}
