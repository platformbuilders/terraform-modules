# Taxonomy

Gerencia uma taxonomy no Google Cloud Data Catalog, seguindo padrões de construção e boas práticas.

## Uso

Exemplo de uso deste módulo:

```terraform
module "taxonomy" {
  source                = "github.com/platformbuilders/terraform-modules//google_data_catalog_taxonomy"
  project_id            = var.project_id
  name                  = "exemplo-taxonomy"
  description           = "Descrição da Taxonomy de exemplo"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]

  policy_tags = {
    tag1 = {
      name        = "Tag1"
      description = "Descrição da Tag1"
    }
    tag2 = {
      name        = "Tag2"
      description = "Descrição da Tag2"
    }
    # Adicione mais tags conforme necessário
  }
}
```

Este modulo possui a o id da subnet criada como output e pode ser utilizada da seguinte forma:

```terraform
module.taxonomy.id
```

## Variáveis

Para usar este módulo, você precisará passar as seguintes variáveis:

`project_id`

`name`

`description`

`activated_policy_types`

`policy_tags`

## Outputs

`id`: O ID da taxonomy criada.

## Referência

  - [Terraform Google Provider Data Catalog Taxonomy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_catalog_taxonomy)
