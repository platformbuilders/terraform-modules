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
        cpu        = 2
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
      }
      worker {
        cpu        = 1
        memory_gb  = 6.5
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }
    }
  }

  labels = {
    "env"     = var.environment
    "project" = var.name
  }
}
