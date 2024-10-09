resource "aws_iam_role" "this" {
  name                 = var.name
  description          = var.description
  path                 = var.path
  assume_role_policy   = var.assume_role_policy
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = { for idx, arn in (var.managed_policy_arns != null ? var.managed_policy_arns : []) : idx => arn }

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies != null ? var.inline_policies : {}

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value.policy
}
