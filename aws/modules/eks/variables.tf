variable "name" {
  description = "EKS Regional unique cluster name"
}

variable "eks_version" {
  description = "Kubernetes EKS version"
}

variable "endpoint_private_access" {
  description = "Enable private endpoint access"
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public endpoint access"
  default     = false
}

variable "vpc_id" {
  description = "EKS vpc id"
}

variable "private_subnet_ids" {
  description = "Private subnets ids"
}

variable "public_subnet_ids" {
  description = "Public subnets ids"
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}

variable "disk_size_gb" {
  description = "Node disk size in Gigabites"
  default     = 50
  type        = string
}

variable "instance_type_list" {
  description = "Lista de tipos de instância permitidos para os grupos de nodes gerenciados."
  type        = list(string)
}

variable "eks_min_instance_node_group" {
  description = "Número mínimo de instâncias para os grupos de nodes gerenciados."
  type        = number
}

variable "eks_max_instance_node_group" {
  description = "Número máximo de instâncias para os grupos de nodes gerenciados."
  type        = number
}

variable "additional_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for [key administrators](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators). If no value is provided, the current caller identity is used to ensure at least one key admin is available"
  type        = list(string)
  default     = []
}

variable "ebs_service_account_role" {
  description = "The role ARN used in service account to ebs addon"
  type        = string
  default     = null
}
