variable "lambda_function_arn" {
  description = "The ARN of the Lambda function to be invoked"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "rds_instances" {
  description = "Map of RDS instances to be managed"
  type = map(object({
    instance_id = string
    instance_arn = string
  }))
}

# Kept for backward compatibility
variable "rds_instance_id" {
  description = "The ID of the RDS instance to be managed (deprecated, use rds_instances instead)"
  type        = string
  default     = null
  nullable    = true
}

variable "start_time_cron" {
  description = "Cron expression for starting RDS instances (in UTC)"
  type        = string
  default     = "cron(30 8 ? * MON-FRI *)" # 08:30 UTC = 05:30 BRT
}

variable "stop_time_cron" {
  description = "Cron expression for stopping RDS instances (in UTC)"
  type        = string
  default     = "cron(30 23 ? * MON-FRI *)" # 23:30 UTC = 20:30 BRT
}

variable "timezone_description" {
  description = "Description of the timezone used in the cron expressions"
  type        = string
  default     = "BRT (UTC-3)"
} 