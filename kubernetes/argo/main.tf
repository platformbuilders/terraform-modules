data "http" "install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argocd_version}/manifests/install.yaml"
}

locals {
  resources = split("\n---\n", data.http.install.response_body)
}

resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_manifest" "apply_argocd_manifests" {
  count = length(local.resources)

  timeouts {
    create = "5m"
    delete = "5m"
  }

  namespace = var.namespace
  content   = local.resources[count.index]

  depends_on = [kubernetes_namespace.argo]
}
