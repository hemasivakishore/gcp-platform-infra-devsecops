terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "7.16.0"
        }
    }
}

provider "google" {
    # configuration options
    project = "project-1e2da3fc-bb97-4b70-9c0"
    region = "us-east1"
    credentials = file("C:/Users/VHS Kishore/Downloads/sa.json")
}