variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "name" {
  type        = string
  description = "Composer name"
}

variable "service_account" {
  type        = string
  description = "The service account to use for Composer"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "kms_key_name" {
  type        = string
  description = "KMS Key name -- projects/[PROJECT_ID]/locations/[LOCATION]/keyRings/[KEYRING_NAME]/cryptoKeys/[KEY_NAME]"
}

variable "pods_cidr" {
  type        = string
  description = "CIDR for pods"
  default     = ""
}

variable "image_version" {
  type        = string
  description = "The Composer image version to use"
  default     = "composer-2.1.3-airflow-2.3.4"
}

variable "env_variables" {
  type        = map(string)
  description = "The Composer environment variables to use"
  default = {

  }
}

variable "airflow_config_overrides" {
  type        = map(string)
  description = "The Composer Airflow config overrides to use"
  default = {
    secrets-backend           = "airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend"
    smtp-smtp_port            = ""
    smtp-smtp_mail_from       = ""
    smtp-smtp_host            = ""
    smtp-smtp_starttls        = true
    smtp-smtp_password_secret = ""
    smtp-smtp_user            = ""
    email-email_backend       = ""
  }
}

variable "pypi_packages" {
  type        = map(string)
  description = "The Composer PyPI packages to use"
  default = {
    "apache-airflow-providers-google"          = "==8.3.0"
    "apache-airflow-providers-amazon"          = "==5.0.0"
    "openpyxl"                                 = "==3.0.10"
    "prettytable"                              = "==3.4.1"
    "unidecode"                                = "==1.3.4"
    "apache-airflow-providers-microsoft-mssql" = "==3.2.0"
    "oracledb"                                 = "==1.0.3"
    "fastavro"                                 = "==1.6.0"
  }
}
