provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

terraform {
  backend "gcs" {
  }
}

data "google_compute_zones" "available_zones" {
  project = var.project
  region = var.region
}

resource "random_shuffle" "random_zone" {
  input = data.google_compute_zones.available_zones.names
  result_count = 1
}

resource "google_compute_instance" "cloud-dev-ide-test" {

  project = var.project
  zone = random_shuffle.random_zone.result[0]
  name = var.instance_name
  machine_type = var.instance_type
  tags = ["code-server"]

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = var.vpc_subnetwork_name
    subnetwork_project = var.project

    access_config {
      // Ephemeral IP
    }
  }

  allow_stopping_for_update = true
  scheduling {
    preemptible = true
    automatic_restart = false
  }

  labels = {
    service = "cloud-dev-ide"
  }
}

terraform {
  required_version  = "=0.12.12"
}

variable "project" {
  type = string
}

variable "credentials" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "instance_name" {
  type = string
  default = "machine1"
}

variable "vpc_network_name" {
  type        = string
  default     = "default"
}

variable "vpc_subnetwork_name" {
  type        = string
  default     = "default"
}

variable "instance_type" {
  type = string
  default = "g1-small"
}

variable "instance_image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-1910"
}

output "instance_zone" {
  value = google_compute_instance.cloud-dev-ide-test.zone
}
