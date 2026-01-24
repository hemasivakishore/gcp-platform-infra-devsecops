terraform {
  backend "gcs" {
    bucket = "gcp-platform-infra"
    prefix = "terraform/state"
  }
}