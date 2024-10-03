resource "google_redis_instance" "cache" {
  name                    = var.name
  project                 = var.project_id
  tier                    = var.tier
  memory_size_gb          = var.memory
  location_id             = var.region
  auth_enabled            = true
  transit_encryption_mode = var.transit_encryption_mode
  authorized_network      = var.authorized_network
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  display_name            = var.display_name
}
