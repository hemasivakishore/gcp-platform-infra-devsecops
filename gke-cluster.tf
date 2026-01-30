#############################################
# GKE CLUSTER (PRODUCTION GRADE)
#############################################

resource "google_container_cluster" "primary" {
  name     = var.cluster-name
  location = var.cluster-region

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet-1.name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  #################################################
  # Labels
  #################################################
  resource_labels = {
    environment = "production"
    owner       = "platform-team"
    project     = "gcp-platform"
  }

  #################################################
  # Private Cluster
  #################################################
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #################################################
  # Authorized Control Plane Access
  #################################################
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/16"
      display_name = "internal-vpc"
    }
  }

  #################################################
  # Networking
  #################################################
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}

  network_policy {
    enabled = true
  }

  #################################################
  # Release Channel
  #################################################
  release_channel {
    channel = "REGULAR"
  }

  #################################################
  # Observability
  #################################################
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
  # Shielded Control Plane
  #################################################
  enable_shielded_nodes = true

  #################################################
  # Authentication Hardening
  #################################################
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  #################################################
  # Workload Identity
  #################################################
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

#############################################
# NODE POOL
#############################################

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
    image_type   = "COS_CONTAINERD"

    #################################################
    # Service Account
    #################################################
    service_account = google_service_account.sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    #################################################
    # Metadata Server v2 (tfsec fix)
    #################################################
    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    #################################################
    # Shielded VM
    #################################################
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    #################################################
    # Labels & Tags
    #################################################
    labels = {
      environment = "production"
      pool        = "primary"
    }

    tags = ["gke-node"]
  }
}

#############################################
# CENTRALIZED LOGGING
#############################################

resource "google_logging_project_bucket_config" "gke_logs" {
  project        = var.project_id
  location       = "global"
  bucket_id      = "prod-gke-cluster-logs"
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
