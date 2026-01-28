#gke-cluster.tf
resource "google_container_cluster" "primary" {
  name     = var.cluster-name
  location = var.cluster-region

  # enable_autopilot = false
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet-1.name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  #################################################
  # Cluster Labels (Asset Management)
  #################################################
  resource_labels = {
    environment = "production"
    owner       = "platform-team"
    project     = "gcp-platform"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/16"
      display_name = "internal-vpc"
    }
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

  network_policy {
    enabled = true
  }

  #################################################
  # Logging & Monitoring
  #################################################
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "REGULAR"
  }

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS"
    ]
  }
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

  #################################################
  # Master Auth (Disable Basic Auth & Client Cert)
  #################################################
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = var.nodes-name
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  node_count = 2

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
    disk_type    = "pd-standard"

    image_type = "COS_CONTAINERD"

    service_account = google_service_account.sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    labels = {
      environment = "production"
      temp        = "initial-pool"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = ["gke-node"]
  }
}

resource "google_logging_project_bucket_config" "gke_logs" {
  project        = var.project_id
  location       = "global"
  bucket_id      = "gke-observability-logs"
  retention_days = 30
}

resource "google_logging_project_sink" "gke_sink" {
  name        = "gke-logs-to-gcs"
  destination = "storage.googleapis.com/gcp-platform-infra-logs"
  filter      = "resource.type = k8s_container"

  unique_writer_identity = true
}

resource "google_storage_bucket_iam_member" "sink_writer" {
  bucket = "gcp-platform-infra-logs"
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.gke_sink.writer_identity
}