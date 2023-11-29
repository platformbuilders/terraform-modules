variable "cluster_name" {
  description = "EKS Regional unique cluster name"
  type        = string
}

variable "nodegroup_name" {
  description = "EKS nodegroup name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Nodes private subnet ids"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired quantity of nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum quantity of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum quantity of nodes"
  type        = number
  default     = 10
}

variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
}

variable "disk_size_gb" {
  description = "Node disk size in Gigabites"
  default     = "100"
  type        = string
}

variable "disk_type" {
  description = "Node disk type"
  default     = "gp3"
  type        = string
}

variable "key_pair_name" {
  description = "Keypair for remote ssh access"
  type        = string
}

variable "instance_type" {
  description = "AWS Instance type"
  default     = "t3.medium"
}

variable "cluster_sg_id" {
  description = "EKS Cluster security group id"
}

variable "eks_nodegroup_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role that provides permissions for the Kubernetes service account"
  type        = string
}
