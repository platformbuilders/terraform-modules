## Kubernetes Cluster Autoscaler Service Account
resource "kubernetes_service_account" "eks_cluster_autoscaler_sa" {
  metadata {
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    name = "cluster-autoscaler"
		namespace = "kube-system"    
		annotations = {
			"eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_autoscaler_role.arn
		}
  }
}

## Cluster autoscaler cluster role
resource "kubernetes_cluster_role" "eks_cluster_autoscaler_cr" {
  metadata {
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    name = "cluster-autoscaler"
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }  

  rule {
    api_groups = [""]
    resources = ["pods/eviction"]
    verbs = ["create"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/status"]
    verbs = ["update"]
  }

  rule {
    api_groups = [""]
    resources = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["watch", "list", "get", "update"]
  }
  
  rule {
    api_groups = [""]
    resources = [
      "pods",
      "services",
      "replicationcontrollers",
      "persistentvolumeclaims",
      "persistentvolumes"
    ]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources = ["statefulsets", "replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses", "csinodes"]
    verbs = ["watch", "list", "get"]
  }
  
  rule {
    api_groups = ["batch", "extensions"]
    resources = ["jobs"]
    verbs = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }

  rule{
    api_groups = ["coordination.k8s.io"]
    resource_names = ["cluster-autoscaler"]
    resources = ["leases"]
    verbs = ["get", "update"]
  }

}

## Cluster autoscaler cluster role binding
resource "kubernetes_cluster_role_binding" "eks_cluster_autoscaler_crb" {
  metadata {
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    name = "cluster-autoscaler"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-autoscaler"
  }

  subject {
    kind = "ServiceAccount"
    name = "cluster-autoscaler"
    namespace = "kube-system"
  }
}

## Cluster autoscaler role
resource "kubernetes_role" "eks_cluster_autoscaler_r" {
  metadata {
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    name = "cluster-autoscaler"
		namespace = "kube-system"  
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create","list","watch"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
    verbs = ["delete", "get", "update", "watch"]
  }

}


## Cluster autoscaler role binding
resource "kubernetes_role_binding" "eks_cluster_autoscaler_rb" {
  metadata {
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
      "k8s-app" = "cluster-autoscaler"
    }
    name = "cluster-autoscaler"
		namespace = "kube-system"  
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-autoscaler"    
  }

  subject {
    kind = "ServiceAccount"
    name = "cluster-autoscaler"
    namespace = "kube-system"    
  }
}

## Cluster autoscaler deployment
resource "kubernetes_deployment" "eks_cluster_autoscaler_deploy" {
  metadata {
    name = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      "app" = "cluster-autoscaler"
    }
  }

  spec {
    replicas = "1"
    selector {
      match_labels = {
        "app" = "cluster-autoscaler"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "cluster-autoscaler"
        }
        annotations = {
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
          "prometheus.io/scrape" = "true"
          "prometheus.io/port" = "8085"
        }
      }
      spec {
        service_account_name = "cluster-autoscaler"
        container {
          image = "k8s.gcr.io/autoscaling/cluster-autoscaler:v${var.cluster_autoscaler_version}"
          name = "cluster-autoscaler"
          resources {
            limits = {
              "cpu" = "200m"
              "memory" = "700Mi"
            }
            requests = {
              "cpu" = "200m"
              "memory" = "700Mi"
            }
          }
          command = [ 
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.cluster_name}",
            "--balance-similar-node-groups",
            "--skip-nodes-with-system-pods=false"
          ]
          volume_mount {
            name = "ssl-certs"
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            read_only = true
          }
          image_pull_policy = "Always"
        }
        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
      }
    }
  }

} 
