terraform {
  required_version = ">= 1.12.1"
  backend "gcs" {
    bucket = "gcp-platform-infra"
    prefix = "terraform/state"
  }
}