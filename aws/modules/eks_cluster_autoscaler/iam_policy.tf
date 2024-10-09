## Cluster Autoscaler Policy
resource "aws_iam_policy" "eks_cluster_autoscaler_policy" {
  name        = "${var.cluster_name}-eks-cluster-autoscaler-policy"
  path        = "/"
  description = "AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            Resource = "*",
            Effect = "Allow"
        }
    ]
	})

  tags = merge(
    var.additional_tags,
    {
    cluster-name = var.cluster_name
    },
  ) 	

} 
