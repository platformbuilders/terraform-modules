
# VPC

Gerencia Compute instance no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "airflow-vm" {
  source = "github.com/platformbuilders/terraform-modules//gcp/compute_instance"

  project_id   = var.project_id
  zone         = var.zone
  name         = "vm-airflow"
  machine_type = "n2-standard-2"
  tags = [
    "airflow-http"
  ]

  environment = "dev"
  image       = "debian-cloud/debian-11"
  disk_size   = 50

  network         = module.vpc.id
  subnet          = module.subnet.id
  external_access = true

  startup_script = data.template_file.init-airflow.rendered
}

module "airflow-power-bi" {
  source = "github.com/platformbuilders/terraform-modules//gcp/compute_instance"

  project_id   = var.project_id
  zone         = var.zone
  name         = "vm-power-bi"
  machine_type = "n2-custom-4-19712"
  tags = [
    "airflow-rdp"
  ]

  environment = "dev"
  image       = "windows-cloud/windows-2022"
  disk_size   = 100

  network         = module.vpc.id
  subnet          = module.subnet.id
  external_access = true
}
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`zone`

`environment`

`name`

`network`

`subnet`

`machine_type`

`tags`

`image`

`disk_size`

`ssh_keys`

`service_account`

`service_account_scopes`

`resource_policies`

`startup_script` - (Opcional) Script de inicialização

`external_access` - (Opcional) Se definido igual a `true` a VM terá um ip publico. Default `false`


## Referência

 - [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)

