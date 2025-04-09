resource "google_storage_bucket" "_" {
  project                     = var.project_id
  name                        = format("%s-%s", var.name, var.environment)
  location                    = var.region
  uniform_bucket_level_access = true

  labels = {
    "env"     = var.environment
    "project" = var.name
  }
  encryption {
    default_kms_key_name = var.kms_key_name
  }
  versioning {
    enabled = true
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age                        = lifecycle_rule.value.condition.age
        days_since_custom_time     = lifecycle_rule.value.condition.days_since_custom_time
        days_since_noncurrent_time = lifecycle_rule.value.condition.days_since_noncurrent_time
        matches_prefix             = lifecycle_rule.value.condition.matches_prefix
        matches_storage_class      = lifecycle_rule.value.condition.matches_storage_class
        matches_suffix            = lifecycle_rule.value.condition.matches_suffix
        num_newer_versions        = lifecycle_rule.value.condition.num_newer_versions
        with_state               = lifecycle_rule.value.condition.with_state
      }
      action {
        type = lifecycle_rule.value.action.type
      }
    }
  }
}
