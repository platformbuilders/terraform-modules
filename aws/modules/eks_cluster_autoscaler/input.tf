variable "cluster_name" {
  description = "EKS Regional unique cluster name"
}

variable "cluster_autoscaler_version" {
  description = "Most recente Autoscaler version which match with eks version. Ex: eks 1.18 --> autoscaler 1.18.X"
}

variable "oidc_url" {
  description = "Open Identity Connector Provider url"
} 


variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
} 
