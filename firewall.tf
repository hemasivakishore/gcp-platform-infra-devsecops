resource "google_compute_firewall" "gke_internal" {
    name = var.firewall_internal_name
    network = google_compute_network.vpc.name

    direction = "INGRESS"
    priority = 1000

    source_ranges = [
        "10.0.0.0/16"
    ]

    allow {
        protocol = "tcp"
        ports = ["0-65535"]
    }

    allow {
        protocol = "udp"
        ports = ["0-65535"]
    }

    allow {
        protocol = "icmp"
    }
}