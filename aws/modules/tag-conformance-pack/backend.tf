module "backend_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  create_bucket = var.create_tf_backend

  bucket                   = "tag-conformance-pack-terraform-${replace(lower(var.profile), "_", "-")}"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

module "backend_dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  create_table = var.create_tf_backend_dynamo_table

  name                           = "tag-conformance-pack-terraform-${replace(lower(var.profile), "_", "-")}"
  server_side_encryption_enabled = true
  hash_key                       = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}