module "ConformancePack" {
  source = "../module/tag-conformance-pack"

  profile                        = var.profile
  bucket_name                    = var.bucket_name
  application_domain_path        = var.application_domain_path
  RemediationExecutionControls   = var.RemediationExecutionControls
  resource_types                 = var.resource_types
  custom_lambda_resource_types   = var.custom_lambda_resource_types
  create_event_bridge_tagger     = var.create_event_bridge_tagger
  script_path                    = var.script_path
  ssm_script                     = var.ssm_script
  custom_lambda_script           = var.custom_lambda_script
  event_bridge_tagger_script     = var.event_bridge_tagger_script
  tags                           = var.tags
  script_policy                  = data.aws_iam_policy_document.script_policy.json
}
