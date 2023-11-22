
# ArgoCD

Faz o deploy do argocd em um cluster kubernetes.

## Uso

Exemplo de uso deste modulo:

```terraform
module "argocd" {
  source         = "github.com/platformbuilders/terraform-modules//kubernetes/argo"
  argocd_version = "stable"
}
```

## Variáveis

Para usar este modulo, você vai precisar passar as seguintes variáveis:

`namespace`

`argocd_version`

