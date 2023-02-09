provider "google"{
    project = var.project_id
    region = var.region
}

terraform {
  backend "gcs"{
    bucket = "stack-state-gcs-data-pipeline2204"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "v0.2.5"
    }
  }
}
