# automation documents must use version 0.3
# https://docs.aws.amazon.com/systems-manager/latest/userguide/documents-schemas-features.html
resource "aws_ssm_document" "SsmDocumentTagRemediation" {
  name            = "SsmDocumentTagRemediation"
  document_format = "YAML"
  document_type   = "Automation"
  content         = local.ssm_content
}
