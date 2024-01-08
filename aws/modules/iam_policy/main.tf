resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  path        = var.path
  tags        = var.tags
  policy      = var.policy
}
