terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.1"
    }
  }
}

provider "google" {
  # configuration options
  project = var.project_id
  region  = var.region
}

provider "local" {

}
