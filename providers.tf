# qual providers de cloud que vamos utilizar

provider "google"{
  project = var.project_id
  region = var.region
}

terraform {
  backend "gcs"{ # fala que vai ser salvo no gcstorage
    bucket = "bucket_lucas2204"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
        source = "hashicorp/google"
        
    }
  }
}
