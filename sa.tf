# sa.tf
resource "google_service_account" "sa" {
  account_id   = "github-actions-terraform"
  display_name = "service account for github-actions and terraform"
  description  = "this service account is used for githubactions and terraform"
}

# Provide IAM Role to the Service Account
resource "google_project_iam_member" "sa_role_binding" {
  # Create one resource for each role in the set
  for_each = local.project_roles

  project = var.project_id
  #role    = "roles/viewer" #grants the viewer role
  role   = each.key
  member = "serviceAccount:${google_service_account.sa.email}"
}
