variable "tags" {
  type    = map(string)
  default = {}
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "Name of bucket for save function.zip "
}

variable "environment_variables" {
  type        = map(string)
  description = "variables of the environments for use the script "
}

variable "function_name" {
  type        = string
  description = "nome da função, podem ser: eks, ec2, elb, etc. Deve existir o codigo da função em src"
}

variable "files_for_zip" {
  type        = string
  description = "Arquivos para ser usado no Command de zip ex: ../../src/__init__.py ../../src/mineracao.py"
}