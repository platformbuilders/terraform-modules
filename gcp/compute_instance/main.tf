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

  can_ip_forward = var.can_ip_forward

  # windows
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
    disk_encryption_key_raw = var.kms_key_self_link
  }

  allow_stopping_for_update = true

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    dynamic "access_config" {
      for_each = var.external_access ? [1] : []
      content {
        network_tier = "PREMIUM"
        nat_ip       = google_compute_address.default.address
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

  resource_policies = concat(
    var.resource_policies,
    var.schedule_shutdown ? [google_compute_resource_policy.shutdown-policy.0.id] : []
  )
}

resource "google_compute_address" "default" {
  project = var.project_id
  name    = "${var.name}-address"
  region  = var.region
}

resource "google_compute_resource_policy" "shutdown-policy" {
  count = var.schedule_shutdown ? 1 : 0

  project     = var.project_id
  name        = "${var.name}-shutdown-policy"
  description = "Job para ligar e desligar a VM"

  instance_schedule_policy {
    vm_stop_schedule {
      schedule = var.schedule_shutdown_cron
    }
    time_zone = var.schedule_shutdown_time_zone
  }
}
