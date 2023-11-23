data "aws_iam_policy_document" "cloudwatch_read_policy" {
  statement {
    actions = [
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    ]
  }
}

module "aws_sso_permission_set" {
  source = "./modules/permission_set"

  permission_set_name = "ExemploPermissionSet"
  instance_arn        = "arn:aws:sso:::instance/ssoins-7223a47d961775f7"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy = data.aws_iam_policy_document.cloudwatch_read_policy.json
  description         = "Exemplo de Permission Set "
  session_duration    = "PT2H"
  tags                = { Environment = "dev" }
}
