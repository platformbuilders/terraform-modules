data "google_compute_network" "network" {
  name = var.authorized_network
}

resource "google_compute_global_address" "service_range" {
  name          = "${var.name}-redis-service-range"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.network.id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = data.google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  update_on_creation_fail = true
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}

resource "google_redis_instance" "cache" {
  depends_on = [
    google_service_networking_connection.private_service_connection,
    google_compute_global_address.service_range
  ]
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
