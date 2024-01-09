terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket"
    prefix = "central-logging/terraform/state/env/"
  }
}