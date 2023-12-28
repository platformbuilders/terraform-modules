variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type        = string
  description = "Profile a ser utilizado para o ambiente em questao"
}

variable "default_tags" {
  type = map(string)
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "Name of bucket for save function.zip and tfstate"
}
variable "environment_variables" {
  type        = map(string)
  description = "variables of the environments for use the script "
  default     = {}
}

variable "account_name" {
  type = string
}