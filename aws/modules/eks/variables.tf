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
