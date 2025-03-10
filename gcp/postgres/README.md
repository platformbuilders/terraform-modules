
# Postgres

Gerencia um banco de dados Postgres no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "postgres" {
  source            = "github.com/platformbuilders/terraform-modules//gcp/postgres"
  project_id        = var.project_id
  name              = var.name
  postgres_version  = var.postgres_version
  region            = var.region
  instance_tier     = var.instance_tier
  edition           = var.edition
  psc_enabled       = var.psc_enabled
  backup_configuration = var.backup_configuration
  start_time        = var.start_time
  availability_type = var.availability_type
}
```

Este modulo possui o nome da instância criada como output e pode ser utilizada da seguinte forma:

```terraform
module.postgres.db_instance_name
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`network`

`postgres_version`

`region`

`instance_tier`

`edition`

`psc_enabled`

`backup_configuration`

`start_time`

`availability_type`

* Caso psc_enabled seja definida como `true` é necessário fazer o setup das seguintes configurações no mesmo manifesto:

`google_compute_global_address`

`google_service_networking_connection`

`google_compute_address`

`google_compute_forwarding_rule`

* Além disso, também será necessário fazer o setup das seguintes configurações no manifesto de Network:

`google_compute_network_peering_routes_config`

`google_dns_managed_zone`

`google_dns_record_set`

## Referência

  - [Terraform Google SQL Database Instance](https://registry.terraform.io/providers/hashicorp/google/3.49.0/docs/resources/sql_database_instance#example-usage)

