output "db_instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = module.postgres.db_instance_name
}

# Habilitar quando psc_enabled = true

# output "db_instance_self_link" {
#   description = "Self-link of the Cloud SQL instance"
#   value       = google_sql_database_instance.main.self_link
# }

# output "psc_private_address" {
#   description = "Private Service Connect address of the Cloud SQL instance"
#   value       = google_sql_database_instance.main.connection_name
# }
