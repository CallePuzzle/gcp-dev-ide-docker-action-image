/*
** Variables
*/
variable "project" {
  type = string
  default = "callepuzzle-lab"
}

variable "region" {
  type = string
  default = "us-east1"
}

/*
** Provider
*/
provider "google" {
  project     = var.project
  region      = var.region
}
provider "github" {
  organization = "CallePuzzle"
}

/*
** Terraform config
*/
terraform {
  backend "gcs" {
    bucket = "callepuzzle-lab-gcp-dev-ide-docker-action-image-ci-tfstate"
  }
  required_version = ">= 0.12.12"
}

/*
** Service account
*/
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 2.0"
  project_id    = var.project
  generate_keys = true
  names         = ["dev-ide-docker-action-image-sa"]
  project_roles = [
    "${var.project}=>roles/compute.instanceAdmin.v1",
    "${var.project}=>roles/storage.admin",
  ]
}

/*
** Secrets
*/
locals {
  api_secrets = {
    CT_PROJECT_ID = var.project
    REGION = var.region
    CT_BUCKET = "callepuzzle-lab-gcp-dev-ide-docker-action-image-ci-tfstate"
    CT_SA_KEY = base64encode(module.service_accounts.key)
  }
}

resource "github_actions_secret" "api" {
  for_each = local.api_secrets
  provider = github
  repository = "gcp-dev-ide-docker-action-image"
  secret_name      = each.key
  plaintext_value  = each.value

  depends_on = [module.service_accounts]
}

/*
** Outpus
*/
output "email" {
  sensitive = true
  value = module.service_accounts.email
}

output "key" {
  sensitive = true
  value = module.service_accounts.key
}
