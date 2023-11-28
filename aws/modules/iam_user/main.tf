resource "aws_iam_user" "this" {
  name = var.user_name
  path = var.path
  tags = var.tags
}


resource "aws_iam_user_policy_attachment" "managed" {
  for_each = var.managed_policy_arns != null ? toset(var.managed_policy_arns) : []
  
  user       = aws_iam_user.this.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "inline" {
  for_each = var.inline_policies != null ? var.inline_policies : {}

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value.policy
}
