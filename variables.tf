variable "project_id" {
  type    = string
  default = "project-1e2da3fc-bb97-4b70-9c0"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "vpc_name" {
  type    = string
  default = "gcp-github-actions-vpc"
}

variable "subnet_name" {
  type    = string
  default = "subnet-1"
}

variable "subnet_1_cidr_range" {
  type    = string
  default = "192.168.1.0/24"
}

variable "subnet_1_region" {
  type    = string
  default = "us-east1"
}

variable "router-name" {
  type    = string
  default = "gke-route"
}