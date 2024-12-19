output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_status" {
  value = module.eks.cluster_status
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
