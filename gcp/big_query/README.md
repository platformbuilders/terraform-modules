
# VPC

Gerenciar Big Query no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "bq_bronze" {
  source      = "github.com/platformbuilders/terraform-modules//gcp/big_query"
  environment = "dev"
  name        = var.name
  project_id  = var.project_id

  tier   = "bronze"
  region = var.region
}

module "bq_silver" {
  source      = "github.com/platformbuilders/terraform-modules//gcp/big_query"
  environment = "dev"
  name        = var.name
  project_id  = var.project_id

  tier   = "silver"
  region = var.region
}
```

Este modulo possui a o id do dataset criado como output e pode ser utilizada da seguinte forma:

```terraform
module.bq_bronze.dataset_id
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`region`

`environment`

`tier`

## Referência

 - [Terraform Google Provider BigQuery Dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset)

