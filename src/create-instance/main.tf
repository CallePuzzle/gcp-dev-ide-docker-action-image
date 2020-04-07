/*
** Provider
*/
provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

/*
** Config
*/
terraform {
  backend "gcs" {}
  required_version  = ">=0.12.12"
}

/*
** Resources
*/
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
  zone = var.zone != "" ? var.zone: random_shuffle.random_zone.result[0]
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

/*
** Output
*/
output "instance_zone" {
  value = google_compute_instance.cloud-dev-ide-test.zone
}
