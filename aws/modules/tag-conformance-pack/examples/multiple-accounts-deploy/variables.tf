variable "region" {
  type = string
}
variable "profile" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "application_domain_path" {
  type = string
}

variable "resource_types" {
  type        = list(string)
  description = "lista de tipos de recursos para o config validar conformidade"
}

variable "custom_lambda_resource_types" {
  type        = list(string)
  description = "lista de tipos de recursos para o lambdaconfig validar conformidade"
}

variable "custom_lambda_script" {
  type        = string
  description = "script para a função lambda do lambda custom config"
}

variable "script_path" {
  type        = string
  description = "path onde se encontra o script"
}

variable "ssm_script" {
  type        = string
  description = "ssm script name"
}

variable "bucket_name" {
  type        = string
  description = "bucket s3 name for conformance pack files and tfstate"
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

variable "create_tf_backend" {
  type        = bool
  default     = false
  description = "Se é para criar um bucket s3 para o estado do terraform"
}

variable "create_tf_backend_dynamo_table" {
  type        = bool
  default     = false
  description = "Se é para criar um dynamodb table ou não para o state lock do terraform"
}

variable "event_bridge_tagger_script" {
  type = string
}

variable "create_event_bridge_tagger" {
  type = bool
}