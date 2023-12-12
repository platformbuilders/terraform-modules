resource "google_data_catalog_taxonomy" "_" {
  project                = var.project_id
  display_name           = var.name
  description            = var.description
  activated_policy_types = var.activated_policy_types
}

resource "google_data_catalog_policy_tag" "policy_tag" {
  for_each = { for tag in var.policy_tags : tag.name => tag }

  taxonomy     = google_data_catalog_taxonomy._.id
  display_name = each.value.name
  description  = each.value.description
}
