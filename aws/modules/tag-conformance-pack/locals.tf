locals {
  json_data            = jsondecode(file(var.application_domain_path))
  all_application_tags = join(",", distinct([for item in local.json_data : item.application]))
  all_domain_tags      = join(",", distinct([for item in local.json_data : item.domain]))
  custom_lambda_resource_types        = <<-EOT
${indent(10, join("\n", formatlist("- %s", var.custom_lambda_resource_types)))}
EOT
  resource_types       = <<-EOT
${indent(10, join("\n", formatlist("- %s", var.resource_types)))}
EOT
  ssm_script_path = "${var.script_path}/${var.ssm_script}"
  script      = <<EOT
${indent(8, file(local.ssm_script_path))}
EOT
  ssm_content = <<DOC
schemaVersion: "0.3"
assumeRole: "${module.TagRemediationAutomationRole.iam_role_arn}"
parameters:
  RequiredTags:
    type: String
    description: (Required) required conformance tags.
    displayType: textarea
  ResourceID:
    type: String
    description: (Required) non-compliant item ResourceID.
    displayType: textarea
  ConformancePackName:
    type: String
    description: (Required) Conformance Pack name pass to the automation.
    displayType: textarea
  BucketS3ApplicationDomainKey:
    type: String
    description: (Required) Conformance Pack name pass to the automation.
    displayType: textarea
  BucketS3Name:
    type: String
    description: (Required) Conformance Pack name pass to the automation.
    displayType: textarea
  AutomationAssumeRole:
    type: String
    description: (Optional) The ARN of the role that allows Automation to perform the actions on your behalf.
    default: ""
    allowedPattern: '^arn:aws(-cn|-us-gov)?:iam::\d{12}:role\/[\w+=,.@_\/-]+|^$'
mainSteps:
  - name: SetRequiredTags
    action: "aws:executeScript"
    description: |
      ## SetRequiredTags
      Adds the specified tags to uncompliant resource checked by required-tags managed rule.
      ## Inputs
      * ResourceID: (StringMap) Id of the resource. Necessery to get the arn of the resource.
      * RequiredTags: (StringMap) Config conformance requiredTags.
      * ConformancePackName: (StringMap) The conformance pack that triggered the ssm document automation.
      * BucketS3ApplicationDomainKey: (StringMap) File application-domain.json to be used to guess the right value for application and domain tag keys.
      * BucketS3Name: (StringMap) The bucket name where the application-domain.json file is located.
      ## Outputs
      * SuccessfulResources: A list of the resources that were successfully tagged.
      * FailedResources: A mapList of the resources where tagging failed and the reason for the failure.
    onFailure: Abort
    isCritical: true
    timeoutSeconds: 600
    isEnd: true
    inputs:
      Runtime: python3.8
      Handler: set_required_tags_handler
      InputPayload:
        ResourceID: "{{ResourceID}}"
        RequiredTags: "{{RequiredTags}}"
        ConformancePackName: "{{ConformancePackName}}"
        BucketS3ApplicationDomainKey: "{{BucketS3ApplicationDomainKey}}"
        BucketS3Name: "{{BucketS3Name}}"
      Script: |
        ${local.script}

DOC
}

