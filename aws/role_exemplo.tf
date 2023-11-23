data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::my_bucket", "arn:aws:s3:::my_bucket/*"]
  }
}

data "aws_iam_policy_document" "cloudwatch_read_policy" {
  statement {
    actions   = ["logs:DescribeLogStreams", "logs:GetLogEvents"]
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*"]
  }
}

module "iam_role" {
  source = "./modules/iam_role"

  name                 = "teste_iam_role"
  description          = "teste iam role"
  path                 = "/"
  permissions_boundary = null
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  tags                 = { "Environment" = "dev" }
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  inline_policies = {
    "s3_access_policy" = {
      policy = data.aws_iam_policy_document.s3_access_policy.json
    },
    "cloudwatch_read_policy" = {
      policy = data.aws_iam_policy_document.cloudwatch_read_policy.json
    }
  }
}
