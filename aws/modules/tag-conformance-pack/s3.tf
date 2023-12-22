module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  create_bucket            = true
  bucket                   = var.bucket_name
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  tags = var.tags

  versioning = {
    enabled = true
  }
}

module "TagRemediationAutomationS3AccessPolicy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.30.2"

  name        = "TagRemediationAutomationS3AccessPolicy"
  path        = "/"
  description = "TagRemediationAutomationS3AccessPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
              "${module.bucket.s3_bucket_arn}",
              "${module.bucket.s3_bucket_arn}/*"
              ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_s3_object" "application_domain_json" {
  bucket = module.bucket.s3_bucket_id
  key    = "files/application_domain.json"
  source = var.application_domain_path

  etag = md5(var.application_domain_path)
}
