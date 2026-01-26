resource "google_container_cluster" "primary" {
  name                = var.cluster-name
  location            = var.region
  network             = google_compute_network.vpc.name
  subnetwork          = google_compute_subnetwork.subnet-1.name
  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  #Networking
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "temporary-open"
    }
  }

  # Security
  enable_shielded_nodes = true

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  # Logging and Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  # Network Policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
}