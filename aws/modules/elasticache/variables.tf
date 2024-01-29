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

variable "parameter_group_name" {
  default = "default.redis2.8"
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
