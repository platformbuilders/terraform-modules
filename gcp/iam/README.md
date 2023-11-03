
# Subnet

Gerencia IAM no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "iam_dags_sync_git_actions" {
  source = "github.com/platformbuilders/terraform-modules//gcp/iam"

  project_id  = var.project_id
  id          = "DagsSyncGitActionsCustomRoleTF"
  title       = "Dags Sync Git Actions Custom Role"
  description = "Dags Sync Git Actions Custom Role"
  permissions = [
    "storage.objects.list",
    "storage.objects.delete",
    "storage.objects.create"
  ]
}
```

Este modulo possui a o id da role criada como output e pode ser utilizada da seguinte forma:

```terraform
module.iam_dags_sync_git_actions.id
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`project_id`

`id`

`title`

`description`

`permissions`

## Referência

  - [Terraform Google Provider IAM Custom Role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_organization_iam_custom_role)
