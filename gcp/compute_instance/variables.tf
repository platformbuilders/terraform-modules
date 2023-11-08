variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "zone" {
  type        = string
  description = "The zone"
  default     = "us-central1-a"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Instance name"
}

variable "network" {
  type        = string
  description = "VPC"
}

variable "subnet" {
  type        = string
  description = "VPC"
}

variable "machine_type" {
  type        = string
  description = "Machine type"
}

variable "tags" {
  type        = list(string)
  description = "tags"
}

variable "image" {
  type        = string
  description = "SKU of the image"
  default     = "debian-cloud/debian-11"
}

variable "disk_size" {
  type        = number
  description = "Boot disk size"
  default     = 50
}

variable "ssh_keys" {
  type        = string
  description = "The SSH keys to use"
  default     = ""
}

variable "service_account" {
  type        = string
  description = "The service account to use for instance"
  default     = ""
}

variable "service_account_scopes" {
  type        = list(string)
  description = "The service account to use for instance"
  default     = ["cloud-platform"]
}

variable "resource_policies" {
  type        = list(string)
  description = "A list of self_links of resource policies to attach to the instance. Modifying this list will cause the instance to recreate. Currently a max of 1 resource policy is supported."
  default     = []
}

variable "startup_script" {
  type        = string
  description = "An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed"
  default     = ""
}

variable "external_access" {
  type        = bool
  description = "Have external access"
  default     = false
}

variable "schedule_shutdown" {
  type        = bool
  description = "Have schedule for VM shutdown"
  default     = false
}

variable "schedule_shutdown_cron" {
  type        = string
  description = "Cron time for VM shutdown"
  default     = "0 20 * * *"
}

variable "schedule_shutdown_time_zone" {
  type        = string
  description = "Time zone of cron time"
  default     = "America/Sao_Paulo"
}
