resource "google_compute_network" "_" {
  name    = var.name
  project = var.project_id

  auto_create_subnetworks = var.auto_create_subnetworks
}