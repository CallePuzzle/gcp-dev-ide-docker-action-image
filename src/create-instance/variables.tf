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

variable "zone" {
  type = string
  default = ""
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
