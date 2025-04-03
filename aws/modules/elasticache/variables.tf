variable "cluster_id" {
  description = "Cluster ID you want to use"
}

variable "port" {
  description = "Port number you want to use"
  default     = 6379
}

variable "engine_version" {
  description = "Redis engine version you want to use"
  default     = "2.8.24"
}
variable "node_type" {
  description = "Node type you want to use"
  default     = "cache.m4.large"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes you want"
  default     = 1
}

variable "security_group_ids" {
  description = "The security_group ids to attach the instance to"
}

variable "name" {
  description = "Cluster Name"
  default     = ""
}

variable "private_subnet_ids" {
  description = "Private subnets ids"
}

variable "public_subnet_ids" {
  description = "Public subnets ids"
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  default     = false
}

variable "snapshot_retention_limit" {
  description = "The number of days for which automated snapshots are retained. If the value is 0, automated snapshots are disabled. Value between 1 and 35."
  default     = 3
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is 30 minutes and the maximum is 7 days."
  default     = "00:00-05:00"
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with this cache cluster. If this argument is omitted, the default parameter group for the specified engine will be used."
  default     = "default.redis3.2.cluster.on"
}

variable "enable_engine_logs" {
  description = "Enables logging on the cache cluster. If enabled, queries and results can be exported to CloudWatch Logs. Note that if you are running Redis version 2.8.0 or later, setting `enable_engine_logs` to true is required in order to be able to use logs. For more information, see [Engine Logs](http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/Log_Delivery_and_Logging.html#Log_Delivery_and_Logging_Enable_Disable). This parameter must be set to `true` when `engine_version` is `2.8.0` or later."
  default     = false
}

variable "log_destination" {
  description = "The destination to send ElastiCache logs to. Can be either 'cloudwatch' or's3'. If the value is not set, no logging will occur."
  default     = ""
}

variable "log_destination_type" {
  description = "The type of destination for ElastiCache logs. Only applicable when `log_destination` is 'cloudwatch'"
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether data modifications should be applied immediately, or during the next maintenance window."
  default     = false
}

variable "additional_tags" {
  description = "Tags to apply to the elasticache."
  type        = map(string)
  default     = null
}