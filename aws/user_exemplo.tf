
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::my_bucket", "arn:aws:s3:::my_bucket/*"]
  }
}

module "iam_user" {
  source = "./modules/iam_user"

  user_name           = "test_user"
  path                = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policies = {
    "s3_access_policy" = {
      policy = data.aws_iam_policy_document.s3_access_policy.json
    }
  }
  tags = { Environment = "dev" }
}
