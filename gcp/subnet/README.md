
# Subnet

Gerencia uma subnet no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "subnet" {
  source     = "github.com/platformbuilders/terraform-modules//gcp/subnet"
  project_id = var.project_id
  region     = var.region
  name       = "${var.name}-subnet"
  network    = module.vpc.id
  cidr       = "10.126.0.0/20"
}
```

Este modulo possui a o id da subnet criada como output e pode ser utilizada da seguinte forma:

```terraform
module.subnet.id
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`name`

`network`

`cidr`

`region`

`have_nat`

`nat_ip_allocate_option`

`source_subnetwork_ip_ranges_to_nat`

`nat_log_enabled`

`nat_log_filter`

* Caso have_nat seja definida como `true` o modulo criar os demais componentes para que o NAT exista corretamente (Router, Address e Router NAT)


## Referência

  - [Terraform Google Provider Subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)

  - [Terraform Google Provider Router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router)

  - [Terraform Google Provider Address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address)

  - [Terraform Google Provider Router NAT](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat)

