resource "google_bigquery_dataset" "_" {
  project       = var.project_id
  dataset_id    = local.tier_name
  friendly_name = local.tier_name
  description   = local.tier_name
  location      = var.region

  max_time_travel_hours = 168
  labels = {
    "env"     = var.environment
    "project" = var.name
  }
}
