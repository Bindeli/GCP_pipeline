# onde criamos os recursos do terraform

resource "google_storage_bucket" "gcs_bucket" {
    name = "gcs-data-pipelinelbm2204"
    location = var.region
}
