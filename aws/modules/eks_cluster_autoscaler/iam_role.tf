// Get AWS Account ID
data "aws_caller_identity" "current" {}

## EKS Cluster Autoscaler role
resource "aws_iam_role" "eks_cluster_autoscaler_role" {

  name = "${var.cluster_name}-eks-cluster-autoscaler-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_url, "https://", "")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
						"${replace(var.oidc_url, "https://", "")}:aud": "sts.amazonaws.com",
            "${replace(var.oidc_url, "https://", "")}:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })

  managed_policy_arns = [ 
  	aws_iam_policy.eks_cluster_autoscaler_policy.arn,
	]

  tags = merge(
    var.additional_tags,
    {
    cluster-name = var.cluster_name
    },
  ) 
} 
