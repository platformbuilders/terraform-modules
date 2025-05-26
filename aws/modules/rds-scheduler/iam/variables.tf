variable "rds_instances" {
  description = "Map of RDS instances to be managed"
  type = map(object({
    instance_id = string
    instance_arn = string
  }))
}

# Kept for backward compatibility
variable "rds_instance_arn" {
  description = "The ARN of the RDS instance to be managed (deprecated, use rds_instances instead)"
  type        = string
  default     = null
} 