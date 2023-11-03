resource "google_compute_instance" "_" {
  project      = var.project_id
  zone         = var.zone
  name         = var.name
  machine_type = var.machine_type
  tags         = var.tags

  labels = {
    "env"   = var.environment
    project = var.name
  }

  # windows
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  allow_stopping_for_update = true

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    dynamic "access_config" {
      for_each = var.external_access ? [1] : []
      content {
        network_tier = "PREMIUM"
      }
    }
  }

  metadata = {
    ssh-keys = var.ssh_keys
  }
  metadata_startup_script = var.startup_script

  dynamic "service_account" {
    for_each = var.service_account != "" ? [1] : []
    content {
      email  = var.service_account
      scopes = var.service_account_scopes
    }
  }

  resource_policies = var.resource_policies
}
