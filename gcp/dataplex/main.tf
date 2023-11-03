resource "google_dataplex_lake" "lake" {
  name         = var.name
  display_name = var.name
  location     = var.region
  project      = var.project_id
  labels = {
    "env"   = var.environment
    project = var.name
  }
}

resource "google_dataplex_zone" "zone" {
  for_each     = { for zone in var.zones : zone.name => zone }
  name         = format("dataplex-%s-%s", each.value.name, var.name)
  display_name = each.value.name
  location     = var.region
  project      = var.project_id
  lake         = google_dataplex_lake.lake.name
  type         = each.value.type

  discovery_spec {
    enabled = false
  }

  resource_spec {
    location_type = "SINGLE_REGION"
  }

  labels = {
    "env"   = var.environment
    project = format("%s-%s", each.value.name, var.name)
  }
}

resource "google_dataplex_asset" "asset" {
  for_each     = { for zone in var.zones : zone.name => zone }
  name         = "asset-${each.value.name}"
  display_name = "asset-${each.value.name}"
  location     = var.region
  project      = var.project_id

  lake          = google_dataplex_lake.lake.name
  dataplex_zone = format("dataplex-%s-%s", each.value.name, var.name)

  labels = {
    "env"   = var.environment
    project = format("%s-%s", each.value.name, var.name)
  }

  discovery_spec {
    enabled  = var.discovery_spec_enabled
    schedule = var.discovery_spec_schedule
  }

  resource_spec {
    name = each.value.resource_spec_name
    type = each.value.resource_spec_type
  }

}

resource "google_dataplex_asset" "lake-inputs" {
  for_each = { for zone in var.zones : zone.name => zone if zone.create_inputs }

  name         = "lake-inputs"
  display_name = "lake-inputs"
  location     = var.region
  project      = var.project_id

  lake          = google_dataplex_lake.lake.name
  dataplex_zone = format("dataplex-%s-%s", each.value.name, var.name)
  labels = {
    "env"   = var.environment
    project = format("%s-%s", each.value.name, var.name)
  }

  discovery_spec {
    enabled = false
  }

  resource_spec {
    name = each.value.inputs_storage
    type = "STORAGE_BUCKET"
  }

}
