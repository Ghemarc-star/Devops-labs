# main.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
  
  # NEW: Separate state file for this pipeline
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create VPC Network
resource "google_compute_network" "prod_network" {
  name                    = "prod-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Create Subnet
resource "google_compute_subnetwork" "prod_subnet" {
  name          = "prod-subnet"
  network       = google_compute_network.prod_network.id
  region        = var.region
  ip_cidr_range = "10.0.0.0/16"
}

# GKE Autopilot Cluster
resource "google_container_cluster" "prod_cluster" {
  name     = "prod-cluster"
  location = var.region
  
  enable_autopilot = true
  
  network    = google_compute_network.prod_network.id
  subnetwork = google_compute_subnetwork.prod_subnet.id
  
  deletion_protection = false
  
  depends_on = [
    google_compute_subnetwork.prod_subnet
  ]
}

# Outputs
output "cluster_name" {
  value = google_container_cluster.prod_cluster.name
}

output "cluster_location" {
  value = google_container_cluster.prod_cluster.location
}

output "network_name" {
  value = google_compute_network.prod_network.name
}

output "node_count_expected" {
  value = var.node_count_expected
}