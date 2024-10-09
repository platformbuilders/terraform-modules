variable "name" {
  description = "MSK cluster name"
}

variable "environment" {
  description = "Environment of the Cluster"
}

variable "msk_kafka_version" {
  description = "Version of the kafka"
}

variable "number_of_brokers" {
  description = "Number of the Brokers on cluster"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of the subnets ids"
  type        = list(string)
}

variable "broker_volume_size" {
  description = "Volume size of the cluster nodes"
  type        = number
  default     = 100
}

variable "max_scaling_volume" {
  description = "Max volume size of node scaling"
  type        = number
  default     = 1000
}

variable "scaling_target" {
  description = "The Kafka broker storage utilization at which scaling is initiated"
  type        = number
  default     = 80
}

variable "broker_instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large."
  default     = "kafka.t3.small"
}

variable "jmx_enabled" {
  description = "Indicates whether you want to enable or disable the JMX Exporter"
  default     = false
}

variable "node_enabled" {
  description = "Indicates whether you want to enable or disable the Node Exporter"
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
}

variable "cidr_blocks_allowed" {
  description = "Security groupid to allow connect with MSK Cluster"
}

variable "public_access" {
  description = "Indicates whether you want to enable or disable public access to the cluster"
  type        = bool
  default     = false
}
