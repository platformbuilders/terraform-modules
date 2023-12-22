module "TagRemediationAutomationRole" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.30.2"

  create_role = true

  role_name         = "TagRemediationAutomationRole"
  role_requires_mfa = false
  trusted_role_services = [
    "ssm.amazonaws.com"
  ]

  custom_role_policy_arns           = [module.TagRemediationAutomationPolicy.arn, module.TagRemediationAutomationS3AccessPolicy.arn]
  number_of_custom_role_policy_arns = 2

}

module "TagRemediationAutomationPolicy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.30.2"

  name        = "TagRemediationAutomationPolicy"
  path        = "/"
  description = "TagRemediationAutomationPolicy"

  policy = var.script_policy
}

