output "taxonomy_id" {
  description = "ID da taxonomy criada"
  value       = google_data_catalog_taxonomy._.id
}

output "policy_tag_ids" {
  description = "IDs das policy tags criadas"
  value       = [for tag in google_data_catalog_policy_tag.policy_tag : tag.id]
}
