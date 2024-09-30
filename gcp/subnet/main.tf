resource "google_compute_subnetwork" "_" {
  project = var.project_id

  name                     = var.name
  network                  = var.network
  ip_cidr_range            = var.cidr
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access
}

resource "google_compute_router" "_" {
  name    = "${var.name}-router"
  project = var.project_id
  network = var.network
  region  = google_compute_subnetwork._.region

  count = var.have_nat ? 1 : 0

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "_" {
  project     = var.project_id
  name        = "${var.name}-nat"
  count       = var.have_nat ? 1 : 0
  description = "The ${var.name} network IP NAT"
  region      = var.region
}

resource "google_compute_router_nat" "_" {
  name                               = "${var.name}-router-nat"
  project                            = var.project_id
  count                              = var.have_nat ? 1 : 0
  region                             = var.region
  router                             = google_compute_router._[count.index].name
  nat_ips                            = google_compute_address._[count.index].*.self_link
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = var.nat_log_enabled
    filter = var.nat_log_filter
  }
}
