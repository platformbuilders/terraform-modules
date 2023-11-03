
# VPC

Gerencia Storage no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "lake" {
  source      = "github.com/platformbuilders/terraform-modules//gcp/storage"
  environment = "dev"
  name        = "lake"
  project_id  = var.project_id

  region = var.region
}
```

Este modulo possui a o id e name do Storage criadp como output e pode ser utilizada da seguinte forma:

```terraform
module.lake.id
module.lake.name
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`region`

`environment`

## Referência

 - [Terraform Google Provider Storage Bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

