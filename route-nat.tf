resource "google_compute_router" "gke-router" {
  name    = "${var.router-name}-${google_compute_subnetwork.subnet-1.region}"
  region  = google_compute_subnetwork.subnet-1.region
  network = google_compute_network.vpc.id
}

# IP Address Allocation for the Route
resource "google_compute_address" "router-ip" {
  count  = 2
  name   = "${var.router-name}-${count.index}"
  region = google_compute_subnetwork.subnet-1.region
  lifecycle {
    create_before_destroy = true
  }
}

# nat-gateway; Cloud NAT Gateway Configuration

resource "google_compute_router_nat" "gke-nat" {
  name                               = "${var.router-name}-nat"
  router                             = google_compute_router.gke-router.name
  region                             = google_compute_router.gke-router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.router-ip.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETS_ALL_IP_RANGES"
}