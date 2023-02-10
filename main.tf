# onde criamos os recursos do terraform

resource "google_storage_bucket" "gcs_bucket" {
    name = "stack-state-gcs-data-pipelinelbm2204"
    location = var.region
}
