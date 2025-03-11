resource "google_sql_database_instance" "main" {
  name             = "${var.name}-postgres"
  database_version = var.postgres_version
  region           = var.region

  settings {
    tier    = var.instance_tier
    edition = var.edition

    ip_configuration {
      # Fazer setup de Private Service Connect para habilitar IP privado aqui
      # psc_config {
      #   psc_enabled               = var.psc_enabled
      #   allowed_consumer_projects = [var.project_id]

      #   psc_auto_connections {
      #     consumer_network            = var.vpc_self_link
      #     consumer_service_project_id = var.project_id
      #   }
      # }

      ipv4_enabled = var.ipv4_enabled
    }

    backup_configuration {
      enabled    = var.backup_configuration
      start_time = var.start_time
    }

    availability_type = var.availability_type
  }

}
