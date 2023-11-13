// Create default node pool with autoscaling
resource "google_container_node_pool" "_" {
  name    = var.node_pool_name
  cluster = var.cluster_name
  project = var.project_id

  ## Same master region or zone
  location = var.master_location

  ## Initial nodes
  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  ## ignore changes made by other resources
  lifecycle {
    ignore_changes = [
      autoscaling,
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
