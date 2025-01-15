variable "region" {
  type        = string
  description = "AWS region to deploy"
}

variable "name" {
  type        = string
  description = "WAF name"
}

variable "description" {
  type        = string
  description = "WAF description"
}

variable "scope" {
  type        = string
  description = "Scope Regional or Cloudfront"
}
  

variable "environment" {
  type        = string
  description = "Environment"
}
