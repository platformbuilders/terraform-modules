resource "google_compute_network" "_" {
  name    = var.name
  project = var.project_id
}