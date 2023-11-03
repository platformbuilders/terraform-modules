
# Subnet

Gerencia regras de firewall no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "firewall-allow-airflow" {
  source     = "github.com/platformbuilders/terraform-modules//gcp/firewall"
  project_id = var.project_id
  network    = module.vpc.id
  name       = "allow-airflow"

  ports = ["8080"]

  target_tags = ["airflow-http"]
  source_ranges = [
    "0.0.0.0/0"
  ]
}
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`network`

`ports`

`source_ranges`

`target_tags`

## Referência

  - [Terraform Google Provider Firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)
