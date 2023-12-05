
# VPC

Gerenciar tabelas e views do Big Query no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "gold_dev_vw_fato_pedido" {
  source = "./modules/bigquery-table"

  project_id  = local.project_id
  dataset_id  = module.operacoes.dataset_gold_dev_id
  table_id    = "vw_fato_pedido_tf"
  description = ""

  #query          = file("../queries/vw_fato_pedido.sql")
  query          = "SELECT * FROM `${local.project_id}.gold_cdp_dev.fato_pedido`"
  use_legacy_sql = false
}
```

Este modulo possui a o id da tabela/view criado como output e pode ser utilizada da seguinte forma:

```terraform
module.gold_dev_vw_fato_pedido.id
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`dataset_id`

`table_id`

`deletion_protection`

`description`

`query`

`use_legacy_sql`

`time_partitioning_field`

`time_partitioning_type`

## Referência

 - [Terraform Google Provider BigQuery Table](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table)

