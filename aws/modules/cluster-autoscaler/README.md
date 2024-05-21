
# Autoscale

## Uso

Exemplo de uso deste modulo:

```terraform
module "cluster-autoscale" {
  source = "github.com/platformbuilders/terraform-modules/aws/modules/cluster-autoscaler"

  cluster_name                     = "eks-gringotts-bb-homolog"
  region                           = "sa-east-1"
  cluster_identity_oidc_issuer     = "oidc.eks.sa-east-1."
  cluster_identity_oidc_issuer_arn = "arn:aws:iam::654654406761:oidc-provider"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
    }
  }
}

provider "aws" {
  region = "sa-east-1"

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

```
