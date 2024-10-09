variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "name" {
  type        = string
  description = "Subnet name"
}

variable "network" {
  type        = string
  description = "VPC"
}

variable "cidr" {
  type        = string
  description = "CIDR for subnet"
}

variable "region" {
  type        = string
  description = "Region of subnet"
}

variable "have_nat" {
  type        = bool
  description = "True if subnet have nat"
  default     = false
}

variable "nat_ip_allocate_option" {
  type        = string
  description = "How external IPs should be allocated for this NAT (Only work if have_nat is true)"
  default     = "MANUAL_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "How NAT should be configured per Subnetwork (Only work if have_nat is true)"
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_log_enabled" {
  type        = bool
  description = "Indicates whether or not to export logs (Only work if have_nat is true)"
  default     = false
}

variable "nat_log_filter" {
  type        = string
  description = "Specifies the desired filtering of logs on this NAT. Possible values are: ERRORS_ONLY, TRANSLATIONS_ONLY, ALL (Only work if have_nat is true)"
  default     = "ERRORS_ONLY"
}

variable "private_ip_google_access" {
  type        = bool
  description = "When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access."
  default     = false
}
