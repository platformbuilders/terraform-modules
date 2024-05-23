variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "engine_type" {
  description = "Type of broker engine"
  type        = string
  default     = "RabbitMQ"
}

variable "engine_version" {
  description = "Version of broker engine"
  type        = string
  default     = "3.11.20"
}

variable "configuration" {
  description = "Configuration of broker engine"
  type        = string
  default     = <<DATA
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
consumer_timeout = 1800000
DATA
}

variable "storage_type" {
  description = "Type of storage"
  type        = string
  default     = "ebs"
}

variable "host_instance_type" {
  description = "Type of instance"
  type        = string
  default     = "mq.t3.micro"
}

variable "deployment_mode" {
  description = "Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. Default is SINGLE_INSTANCE."
  type        = string
  default     = "SINGLE_INSTANCE"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
}

variable "username" {
  description = "Username of broker"
  type        = string
}

variable "password" {
  description = "Password of broker"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "mq_broker_allowed_security_groups" {
  description = "List of security groups to be allowed to connect to the ActiveMQ instance."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to place the broker."
  type        = list(string)
}
