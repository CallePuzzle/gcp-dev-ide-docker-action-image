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
  name = "machine1"
  machine_type = var.instance-type
  tags = ["code-server"]

  boot_disk {
    initialize_params {
      image = var.instance-image
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

variable "vpc_network_name" {
  type        = string
  default     = "default"
}

variable "vpc_subnetwork_name" {
  type        = string
  default     = "default"
}

variable "instance-type" {
  type = string
  default = "g1-small"
}

variable "instance-image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-1910"
}
