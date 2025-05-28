resource "aws_iam_user" "this" {
  name = var.user_name
  path = var.path
  tags = var.tags
}


resource "aws_iam_user_policy_attachment" "managed" {
  count = var.managed_policy_arns != null ? length(var.managed_policy_arns) : 0
  
  user       = aws_iam_user.this.name
  policy_arn = var.managed_policy_arns[count.index]
}

resource "aws_iam_user_policy" "inline" {
  for_each = var.inline_policies != null ? var.inline_policies : {}

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value.policy
}
