terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }

    k8s = {
      source  = "banzaicloud/k8s"
      version = ">= 0.9.1"
    }

    http = {
      source = "hashicorp/http"
    }
  }
  required_version = ">= 0.15"
}

