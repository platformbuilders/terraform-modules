output "id" {
  description = "Storage subnet"
  value       = google_storage_bucket._.id
}

output "name" {
  description = "Storage name"
  value       = google_storage_bucket._.name
}
