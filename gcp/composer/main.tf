resource "google_composer_environment" "composer" {
  project = var.project_id
  name    = format("%s-composer-%s", var.name, var.environment)

  config {
    private_environment_config {
      enable_private_endpoint = true
    }

    node_config {
      network    = var.vpc_id
      subnetwork = var.subnet_id

      service_account = var.service_account

      ip_allocation_policy {
        cluster_ipv4_cidr_block = var.pods_cidr
      }
    }

    encryption_config {
      kms_key_name = var.kms_key_name
    }

    software_config {
      image_version = var.image_version

      env_variables = merge(
        var.env_variables, {
          "AIRFLOW_ENV"     = "production"
          "LD_LIBRARY_PATH" = "/home/airflow/gcs/plugins/oracle/instantclient_12_2"
        }
      )

      airflow_config_overrides = merge(
        var.airflow_config_overrides, {
          webserver-instance_name = "Lakehouse - ${var.environment}"
        }
      )

      pypi_packages = var.pypi_packages
    }

    workloads_config {
      scheduler {
        cpu        = var.workloads_config.scheduler.cpu
        memory_gb  = var.workloads_config.scheduler.memory_gb
        storage_gb = var.workloads_config.scheduler.storage_gb
        count      = var.workloads_config.scheduler.count
      }
      web_server {
        cpu        = var.workloads_config.web_server.cpu
        memory_gb  = var.workloads_config.web_server.memory_gb
        storage_gb = var.workloads_config.web_server.storage_gb
      }
      worker {
        cpu        = var.workloads_config.worker.cpu
        memory_gb  = var.workloads_config.worker.memory_gb
        storage_gb = var.workloads_config.worker.storage_gb
        min_count  = var.workloads_config.worker.min_count
        max_count  = var.workloads_config.worker.max_count
      }
    }
  }

  labels = {
    "env"     = var.environment
    "project" = var.name
  }
}
