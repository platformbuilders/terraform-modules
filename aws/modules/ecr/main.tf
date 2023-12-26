resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [1] : []
    content {
      encryption_type = var.encryption_configuration.encryption_type
      kms_key         = var.encryption_configuration.kms_key
    }
  }

  force_delete = var.force_delete
  tags         = var.tags
}
