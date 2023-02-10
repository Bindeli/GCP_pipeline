# onde criamos os recursos do terraform

#resource "google_storage_bucket" "gcs_bucket" {
#    name = "gcs-data-pipelinelbm2204"
#    location = var.region
#}

# chama o modulo

module "bigquery-dataset-gasolina"" {
    source = ".modules\bigquery"
    dataset_id              =   "gasolina-brasil"
    dataset_name            =   "gasolina-brasil"
    description             =   "Dataset a respeito do historico de preços da gasolina do Brasil a partir de 2004"
    project_id              =   var.project_id
    location                =   var.region
    deletion_contents_on_destroy = true 
    deletion_protection = false
    access = [ #definições de acesso
        {
            role = "OWNER"
            special_group = "projectOwners"
        },
        {
            role = "READER"
            special_group = "projectReaders"
        },
        {
            role = "WRITER"
            special_group = "projectWriters"
        }
    ]

    tables = [  # onde criamos as tabelas
        {
            table_id = "tb_historico_combustivel_brasil"
            description = "Tabela com as informacoes de preço de combustivel ao longo dos anos"
            time_partitioning = {
                type = "DAY",
                field = "data",
                require_partition_filter = false,
                expiration_ms = null
            },
            range_partitioning = null,
            expiration_time = null,
            clustering = ["produto","regiao_sigla","estado_sigla"],
            labels = { # para trackear onde esta consumindo na sua área
                name = "stack_data_pipeline"
                project = "gasolina"
            },
            deletion_protection = true 
            schema = file(".\bigquery\schema\gasolina_brasil\tb_historico_combustivel_brasil.json")

        }
    ]
  
}

module "bucket-raw"{
    source = ".\modules\gcs"

    name       = "data-pipeline-lucasbindeli-raw"
    project_id = var.project_id
    location   = var.region
}

module "bucket-curated" {
    source = ".\modules\gcs"
    name       = "data-pipeline-lucasbindeli-curated"
    project_id = var.project_id
    location   = var.region
}

module "bucket-psypark-tmp" {
    source = ".\modules\gcs"
    name       = "data-pipeline-lucasbindeli-pyspark-tmp"
    project_id = var.project_id
    location   = var.region
}

module "bucket-pyspark-code" {
  source  = ".\modules\gcs"

  name       = "data-pipeline-lucasbindeli-pyspark-code"
  project_id = var.project_id
  location   = var.region
}


