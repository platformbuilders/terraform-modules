variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance to be created."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair."
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched."
  type        = string
}

variable "my_ip" {
  description = "Your IP address with /32 CIDR."
  type        = string
}

variable "tags" {
  description = "Tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "disk_size" {
  description = "Size of the root EBS volume in GiB."
  type        = number
  default     = 16
}

variable "volume_type" {
  description = "The type of volume for the root EBS volume. Options: gp2, gp3, io1, io2, st1, sc1, standard."
  type        = string
  default     = "gp2"
}
