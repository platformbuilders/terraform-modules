variable "tags" {
  type = map(string)
}

variable "application_domain_path" {
  type = string
}

variable "ssm_script" {
  type        = any
  description = "script file."
}

variable "bucket_name" {
  type = string
}

variable "resource_types" {
  type        = list(string)
  description = "lista de tipos de recursos para o config validar conformidade"
}

variable "custom_lambda_resource_types" {
  type        = list(string)
  description = "lista de tipos de recursos para o config validar conformidade"
}

variable "script_path" {
  type        = string
  description = "path onde se encontra o script"
}

variable "custom_lambda_script" {
  type        = string
  description = "script para a função landa do lambda custom config"
}

variable "RemediationExecutionControls" {
  type = object({
    ExecutionControls : object({
      SsmControls = object({
        ConcurrentExecutionRatePercentage = number
        ErrorPercentage                   = number
      })
    })
    Automatic                = bool
    MaximumAutomaticAttempts = number
    RetryAttemptSeconds      = number
  })

  description = "Config Remediation ExecutionControls yaml block"
}

variable "event_bridge_tagger_script" {
  type = string
}

variable "create_event_bridge_tagger" {
  type = bool
}

variable "script_policy" {
  type = any
}

variable "create_tf_backend" {
  type = bool
  default = false
}

variable "create_tf_backend_dynamo_table" {
  type = bool
  default = false
}

variable "profile" {
  type = string
}