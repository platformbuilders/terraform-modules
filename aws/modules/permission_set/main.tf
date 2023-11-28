resource "aws_ssoadmin_permission_set" "this" {
  name           = var.permission_set_name
  instance_arn   = var.instance_arn
  description    = var.description
  session_duration = var.session_duration

  tags = var.tags
}

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  for_each = var.managed_policy_arns != null ? toset(var.managed_policy_arns) : []


  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  instance_arn       = var.instance_arn
  managed_policy_arn = each.value
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  count              = var.inline_policy != null ? 1 : 0
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.inline_policy
}

resource "aws_ssoadmin_permissions_boundary_attachment" "boundary"{
  count              = var.permission_boundary != null ? 1 : 0
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  permissions_boundary {
    customer_managed_policy_reference {
      name = var.permission_boundary
    }
  }
}