variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "region" {
  type        = string
  description = "AWS region where secrets are stored."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "service_account_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Cluster Autoscaler service account name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy Cluster Autoscaler Helm chart."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}

variable "eks_version" {
  default     = "1.29.0"
  description = "Version of EKS"
}
