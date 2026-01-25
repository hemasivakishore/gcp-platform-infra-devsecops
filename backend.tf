terraform {
  required_version = ">= 1.14.1"
  backend "gcs" {
    bucket = "gcp-platform-infra"
    prefix = "terraform/state"
  }
}