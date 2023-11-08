output "id" {
  value = google_container_cluster._.id
}

output "name" {
  value = google_container_cluster._.name
}

output "master_version" {
  value = google_container_cluster._.master_version
}

output "endpoint" {
  value = google_container_cluster._.endpoint
}

output "master_ca" {
  value = google_container_cluster._.master_auth.0.cluster_ca_certificate
}

output "master_location" {
  value = google_container_cluster._.location
}

output "master_cidr" {
  value = google_container_cluster._.private_cluster_config.0.master_ipv4_cidr_block
}
output "pod_cidr" {
  value = google_container_cluster._.ip_allocation_policy.0.cluster_ipv4_cidr_block
}
output "service_cidr" {
  value = google_container_cluster._.ip_allocation_policy.0.services_ipv4_cidr_block
}


