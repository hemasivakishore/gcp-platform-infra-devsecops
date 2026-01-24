resource "google_service_account" "sa" {
  account_id   = "github-actions-terraform"
  display_name = "service account for github-actions and terraform"
  description  = "this service account is used for githubactions and terraform"
}

# Provide IAM Role to the Service Account
resource "google_project_iam_member" "sa_role_binding" {
  project = "project-1e2da3fc-bb97-4b70-9c0"
  role    = "roles/viewer" #grants the viewer role
  member  = "serviceAccount:${google_service_account.sa.email}"
}
