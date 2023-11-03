
# VPC

Gerencia uma rede VPC no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "vpc" {
  source = "github.com/platformbuilders/terraform-modules//gcp/vpc"

  project_id = var.project_id
  name       = "${var.name}-net"
}
```

Este modulo possui a o id da VPC criada como output e pode ser utilizada da seguinte forma:

```terraform
module.vpc.id
```

## Referência

 - [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)

