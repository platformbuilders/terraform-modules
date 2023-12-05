resource "google_bigquery_table" "_" {
  project             = var.project_id
  dataset_id          = var.dataset_id
  table_id            = var.table_id
  deletion_protection = var.deletion_protection
  description         = var.description

  dynamic "view" {
    for_each = var.query == null ? [] : [var.query]
    content {
      query          = view.value
      use_legacy_sql = var.use_legacy_sql
    }
  }

  dynamic "time_partitioning" {
    for_each = var.time_partitioning_field == null ? [] : [var.time_partitioning_field]
    content {
      type  = var.time_partitioning_type
      field = var.time_partitioning_field
    }
  }

}
