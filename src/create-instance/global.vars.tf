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
