#vpc.tf
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet-1" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_1_cidr_range
  region                   = var.subnet_1_region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.7
    metadata             = "INCLUDE_ALL_METADATA"
    filter_expr          = "true"
  }

}