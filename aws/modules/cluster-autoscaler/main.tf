resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }
}

resource "kubernetes_namespace" "cluster_autoscaler" {
  count      = var.namespace != "kube-system" ? 1 : 0
  depends_on = [null_resource.kubectl]

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cluster_autoscaler" {
  depends_on = [null_resource.kubectl, kubernetes_namespace.cluster_autoscaler]
  name       = "cluster-autoscaler"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.37.0"
  namespace  = var.namespace

  set {
    name  = "fullnameOverride"
    value = "aws-cluster-autoscaler"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.kubernetes_cluster_autoscaler.arn
  }

  set {
    name  = "kubeTargetVersionOverride"
    value = var.eks_version
  }

  values = [
    yamlencode(var.settings)
  ]

}
