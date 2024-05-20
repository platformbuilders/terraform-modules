output "eks_cluster_autoscaler_policy_name" {
    value = aws_iam_policy.eks_cluster_autoscaler_policy.name
} 

output "eks_cluster_autoscaler_policy_arn" {
    value = aws_iam_policy.eks_cluster_autoscaler_policy.arn
} 


output "eks_cluster_autoscaler_role_name" {
    value = aws_iam_role.eks_cluster_autoscaler_role.name
} 

output "eks_cluster_autoscaler_role_arn" {
    value = aws_iam_role.eks_cluster_autoscaler_role.arn
} 


