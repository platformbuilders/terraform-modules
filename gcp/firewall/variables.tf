variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "network" {
  type        = string
  description = "VPC"
}

variable "name" {
  type        = string
  description = "Rule name"
}

variable "ports" {
  type        = list(string)
  description = "An list of ports to which this rule applies."
}

variable "source_ranges" {
  type        = list(string)
  description = "If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges."
  default     = ["0.0.0.0/0"]
}

variable "target_tags" {
  type        = list(string)
  description = "A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]."
  default     = []
}

