
# VPC

Gerencia dataplex no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "datalake" {
  source      = "github.com/platformbuilders/terraform-modules//gcp/dataplex"
  environment = "dev"
  name        = "lake"
  project_id  = var.project_id

  region = var.region

  zones = [
    {
      name               = "bronze",
      type               = "RAW",
      resource_spec_name = "projects/${var.project_id}/datasets/${module.bq_bronze.dataset_id}",
      resource_spec_type = "BIGQUERY_DATASET",
      create_inputs      = true,
      inputs_storage     = "projects/${var.project_id}/buckets/${module.lake-inputs.name}"
    },
    {
      name               = "silver",
      type               = "CURATED",
      resource_spec_name = "projects/${var.project_id}/datasets/${module.bq_silver.dataset_id}",
      resource_spec_type = "BIGQUERY_DATASET",
      create_inputs      = false,
      inputs_storage     = ""
    },
    {
      name               = "gold",
      type               = "CURATED",
      resource_spec_name = "projects/${var.project_id}/datasets/${module.bq_gold.dataset_id}",
      resource_spec_type = "BIGQUERY_DATASET",
      create_inputs      = false,
      inputs_storage     = ""
    }
  ]

  depends_on = [
    module.bq_bronze,
    module.bq_silver,
    module.bq_gold
  ]
}
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`region`

`environment`

`discovery_spec_enabled` - Default `true`

`discovery_spec_schedule` - Default "0 12 * * *"

`zones` - É criado um google_dataplex_zone e um google_dataplex_asset por zone, caso create_inputs seja `true` sera criado mais um asset vinculado com um Storage, qual deve ser passado pela variavel `inputs_storage`

## Referência

 - [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)

