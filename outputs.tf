#outputs.tf
#################################################
# GKE Cluster Outputs
#################################################

output "cluster_name" {
  description = "The name of the Kubernetes cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master."
  value       = google_container_cluster.primary.endpoint
  sensitive   = true # Marked sensitive because it's a private endpoint
}

output "cluster_location" {
  description = "The region/zone where the cluster is deployed."
  value       = google_container_cluster.primary.location
}

output "kubernetes_cluster_ca_certificate" {
  description = "Public certificate of the cluster (base64 encoded)."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

#################################################
# Node Pool Outputs
#################################################

output "node_pool_name" {
  description = "The name of the primary node pool."
  value       = google_container_node_pool.primary_nodes.name
}

output "node_pool_status" {
  description = "The current status of the node pool."
  value       = google_container_node_pool.primary_nodes.operation
}

#################################################
# Networking & Identity Outputs
#################################################

output "vpc_id" {
  description = "The ID of the VPC."
  value       = google_compute_network.vpc.id
}

output "nat_ips" {
  description = "The public IP addresses used by the NAT gateway for egress."
  value       = google_compute_address.router-ip[*].address
}

output "service_account_email" {
  description = "The email of the GKE service account."
  value       = google_service_account.sa.email
}

output "workload_identity_pool" {
  description = "The Workload Identity Pool for the cluster."
  value       = google_container_cluster.primary.workload_identity_config[0].workload_pool
}

#################################################
# Helper: kubectl connection command
#################################################

output "get_credentials_command" {
  description = "Command to configure kubectl to connect to this cluster."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${google_container_cluster.primary.location} --project ${var.project_id}"
}

#################################################
# Observability and Logging Outputs
#################################################
output "logging_bucket_id" {
  description = "The ID of the specilized GKE log bucket"
  value = google_logging_project_bucket_config.gke_logs.id
}

output "logging_sink_name" {
  description = "The Service Account identity that writer logs to the destination (used for IAM Vertification)"
  value = google_logging_project_sink.gke_sink.writer_identity
}

#################################################
# Firewall and Security Outputs
#################################################
output "internal_firewall_name" {
  description = "The name of the internal firewall rule allowing cluster communication."
  value = google_compute_firewall.gke_internal.name
}

output "internal_firewall_allowed_ranges" {
  description = "The IP ranges allowed by the internal GKE Firewall"
  value = google_compute_firewall.gke_internal.source_ranges
}