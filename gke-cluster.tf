resource "google_container_cluster" "primary" {
  name     = var.cluster-name
  location = var.region

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet-1.name

  remove_default_node_pool = true
  initial_node_count       = 1

  #################################################
  # Cluster Labels (Asset Management)
  #################################################
  resource_labels = {
    environment = "production"
    owner       = "platform-team"
    project     = "gcp-platform"
  }

  #################################################
  # Private Cluster (No Public Control Plane)
  #################################################
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #################################################
  # Networking & Security Defaults
  #################################################
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}

  #################################################
  # Logging & Monitoring
  #################################################
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  #################################################
  # Shielded Nodes
  #################################################
  enable_shielded_nodes = true

  #################################################
  # Master Auth (Disable Basic Auth & Client Cert)
  #################################################
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}