resource "aws_iam_policy" "kubernetes_cluster_autoscaler" {
  name        = "${var.cluster_name}-cluster-autoscaler"
  path        = "/"
  description = "Policy for cluster autoscaler service"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Action = [
        "eks:DescribeNodegroup",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        ]
        Resource = "*",
        Effect   = "Allow"
      },
      {
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "kubernetes_cluster_autoscaler" {
  name = "${var.cluster_name}-cluster-autoscaler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"

        Principal = {
          Federated = var.cluster_identity_oidc_issuer_arn
        }

        Condition = {
          StringEquals = {
            "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }

        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubernetes_cluster_autoscaler" {
  role       = aws_iam_role.kubernetes_cluster_autoscaler.name
  policy_arn = aws_iam_policy.kubernetes_cluster_autoscaler.arn
}
