output "id" {
  value = google_redis_instance.cache.id
}

output "host" {
  value = google_redis_instance.cache.host
}

output "port" {
  value = google_redis_instance.cache.port
}

output "auth_string" {
  value = google_redis_instance.cache.auth_string
  sensitive = true
}
