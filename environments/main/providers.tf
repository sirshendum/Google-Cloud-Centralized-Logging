terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.48.0"
    }
  }
}

provider "google" {
  impersonate_service_account = var.tf_service_account
  project                     = var.hub_project_id
 }
