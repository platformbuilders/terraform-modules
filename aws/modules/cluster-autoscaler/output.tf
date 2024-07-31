output "aws_iam_policy" {
  value = aws_iam_policy.kubernetes_cluster_autoscaler
}

output "aws_iam_role" {
  value = aws_iam_role.kubernetes_cluster_autoscaler
}

output "aws_iam_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.kubernetes_cluster_autoscaler
}
