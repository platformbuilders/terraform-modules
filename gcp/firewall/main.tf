resource "google_compute_firewall" "_" {
  project = var.project_id
  network = var.network
  name    = var.name

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}
