terraform {
  required_version = ">= 1.12.2"
  backend "gcs" {
    bucket = "gcp-platform-infra"
    prefix = "terraform/state"
  }
}