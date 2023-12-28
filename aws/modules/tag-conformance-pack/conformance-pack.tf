resource "aws_config_conformance_pack" "RequiredTagsConformancePack" {
  name          = "TagRemediationConformancePack"
  template_body = <<EOT
Parameters:
  ConformancePackName:
    Description: The name intented to use when creating the organization comformance pack.
    Default: 'TagRemediationConformancePack'
    Type: String
Mappings:
  RequiredTags:
    tag1:
      key: application
      value: XYZ
    tag2:
      key: domain
      value: XYZ
    tag3:
      key: board
      value: '${var.tags["board"]}'
    tag4:
      key: company
      value: '${var.tags["company"]}'
    tag5:
      key: env
      value: '${var.tags["env"]}'
    tag6:
      key: shared
      value: 'yes,no'

Resources:
  # https://docs.aws.amazon.com/config/latest/developerguide/custom-conformance-pack.html
  ResourceTaggingCheck:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: required-tags
      Description: Check resources against the required tags
      EvaluationModes: DETECTIVE
      Source:
        Owner: AWS
        SourceIdentifier: REQUIRED_TAGS
      Scope:
        ComplianceResourceTypes:
          ${local.resource_types} 
      InputParameters:
        tag1Key: !FindInMap [RequiredTags, tag1, key]
        tag1Value: "${local.all_application_tags}"
        tag2Key: !FindInMap [RequiredTags, tag2, key]
        tag2Value: "${local.all_domain_tags}"
        tag3Key: !FindInMap [RequiredTags, tag3, key]
        tag3Value: !FindInMap [RequiredTags, tag3, value]
        tag4Key: !FindInMap [RequiredTags, tag4, key]
        tag4Value: !FindInMap [RequiredTags, tag4, value]
        tag5Key: !FindInMap [RequiredTags, tag5, key]
        tag5Value: !FindInMap [RequiredTags, tag5, value]
        tag6Key: !FindInMap [RequiredTags, tag6, key]
        tag6Value: !FindInMap [RequiredTags, tag6, value]

  # https://docs.aws.amazon.com/config/latest/developerguide/custom-conformance-pack.html
  CustomResourceTaggingCheck:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: custom-lambda-required-tags
      Description: Check resources against the required tags
      EvaluationModes: DETECTIVE
      Source:
        Owner: CUSTOM_LAMBDA
        SourceIdentifier: ${module.lambda_custom_config_required_tags.lambda_function_arn}
        # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-config-configrule-sourcedetail.html
        SourceDetails:
            -
              EventSource: aws.config
              MessageType: ConfigurationItemChangeNotification
            -
              EventSource: aws.config
              MessageType: OversizedConfigurationItemChangeNotification
      Scope:
        ComplianceResourceTypes:
          ${local.custom_lambda_resource_types}
      InputParameters:
        tag1Key: !FindInMap [RequiredTags, tag1, key]
        tag1Value: "${local.all_application_tags}"
        tag2Key: !FindInMap [RequiredTags, tag2, key]
        tag2Value: "${local.all_domain_tags}"
        tag3Key: !FindInMap [RequiredTags, tag3, key]
        tag3Value: !FindInMap [RequiredTags, tag3, value]
        tag4Key: !FindInMap [RequiredTags, tag4, key]
        tag4Value: !FindInMap [RequiredTags, tag4, value]
        tag5Key: !FindInMap [RequiredTags, tag5, key]
        tag5Value: !FindInMap [RequiredTags, tag5, value]
        tag6Key: !FindInMap [RequiredTags, tag6, key]
        tag6Value: !FindInMap [RequiredTags, tag6, value]

  MapTaggingRemediation:
    DependsOn: ResourceTaggingCheck
    Type: 'AWS::Config::RemediationConfiguration'
    Properties:
      ConfigRuleName: required-tags
      TargetId: !Sub "arn:aws:ssm:$${AWS::Region}:$${AWS::AccountId}:document/${aws_ssm_document.SsmDocumentTagRemediation.name}"
      TargetType: 'SSM_DOCUMENT'
      Parameters:
        RequiredTags:
          StaticValue:
            Values:
              - !Sub
                - '{"$${tag1key}":"$${tag1value}","$${tag2key}":"$${tag2value}","$${tag3key}":"$${tag3value}","$${tag4key}":"$${tag4value}","$${tag5key}":"$${tag5value}"}'
                - tag1key: !FindInMap [RequiredTags, tag1, key]
                  tag1value: !FindInMap [RequiredTags, tag1, value]
                  tag2key: !FindInMap [RequiredTags, tag2, key]
                  tag2value: !FindInMap [RequiredTags, tag2, value]
                  tag3key: !FindInMap [RequiredTags, tag3, key]
                  tag3value: !FindInMap [RequiredTags, tag3, value]
                  tag4key: !FindInMap [RequiredTags, tag4, key]
                  tag4value: !FindInMap [RequiredTags, tag4, value]
                  tag5key: !FindInMap [RequiredTags, tag5, key]
                  tag5value: !FindInMap [RequiredTags, tag5, value]
                  tag6key: !FindInMap [RequiredTags, tag6, key]
                  tag6value: !FindInMap [RequiredTags, tag6, value]

        ConformancePackName:
          StaticValue:
            Values:
              - Ref: ConformancePackName
        BucketS3Name:
          StaticValue:
            Values:
              - '${module.bucket.s3_bucket_id}'
        BucketS3ApplicationDomainKey:
          StaticValue:
            Values:
              - '${aws_s3_object.application_domain_json.key}'
        ResourceID:
          ResourceValue:
            Value: 'RESOURCE_ID'
        AutomationAssumeRole:
          StaticValue:
            Values:
              - '${module.TagRemediationAutomationRole.iam_role_arn}'
      ExecutionControls:
        SsmControls:
          ConcurrentExecutionRatePercentage: '${var.RemediationExecutionControls["ExecutionControls"]["SsmControls"]["ConcurrentExecutionRatePercentage"]}'
          ErrorPercentage: '${var.RemediationExecutionControls["ExecutionControls"]["SsmControls"]["ErrorPercentage"]}'
      Automatic: '${var.RemediationExecutionControls["Automatic"]}'
      MaximumAutomaticAttempts: '${var.RemediationExecutionControls["MaximumAutomaticAttempts"]}'
      RetryAttemptSeconds: '${var.RemediationExecutionControls["RetryAttemptSeconds"]}'

  MapTaggingRemediationCustomLambda:
    DependsOn: CustomResourceTaggingCheck
    Type: 'AWS::Config::RemediationConfiguration'
    Properties:
      ConfigRuleName: custom-lambda-required-tags
      TargetId: !Sub "arn:aws:ssm:$${AWS::Region}:$${AWS::AccountId}:document/${aws_ssm_document.SsmDocumentTagRemediation.name}"
      TargetType: 'SSM_DOCUMENT'
      Parameters:
        RequiredTags:
          StaticValue:
            Values:
              - !Sub
                - '{"$${tag1key}":"$${tag1value}","$${tag2key}":"$${tag2value}","$${tag3key}":"$${tag3value}","$${tag4key}":"$${tag4value}","$${tag5key}":"$${tag5value}"}'
                - tag1key: !FindInMap [RequiredTags, tag1, key]
                  tag1value: !FindInMap [RequiredTags, tag1, value]
                  tag2key: !FindInMap [RequiredTags, tag2, key]
                  tag2value: !FindInMap [RequiredTags, tag2, value]
                  tag3key: !FindInMap [RequiredTags, tag3, key]
                  tag3value: !FindInMap [RequiredTags, tag3, value]
                  tag4key: !FindInMap [RequiredTags, tag4, key]
                  tag4value: !FindInMap [RequiredTags, tag4, value]
                  tag5key: !FindInMap [RequiredTags, tag5, key]
                  tag5value: !FindInMap [RequiredTags, tag5, value]
                  tag6key: !FindInMap [RequiredTags, tag6, key]
                  tag6value: !FindInMap [RequiredTags, tag6, value]

        ConformancePackName:
          StaticValue:
            Values:
              - Ref: ConformancePackName
        BucketS3Name:
          StaticValue:
            Values:
              - '${module.bucket.s3_bucket_id}'
        BucketS3ApplicationDomainKey:
          StaticValue:
            Values:
              - '${aws_s3_object.application_domain_json.key}'
        ResourceID:
          ResourceValue:
            Value: 'RESOURCE_ID'
        AutomationAssumeRole:
          StaticValue:
            Values:
              - '${module.TagRemediationAutomationRole.iam_role_arn}'
      ExecutionControls:
        SsmControls:
          ConcurrentExecutionRatePercentage: '${var.RemediationExecutionControls["ExecutionControls"]["SsmControls"]["ConcurrentExecutionRatePercentage"]}'
          ErrorPercentage: '${var.RemediationExecutionControls["ExecutionControls"]["SsmControls"]["ErrorPercentage"]}'
      Automatic: '${var.RemediationExecutionControls["Automatic"]}'
      MaximumAutomaticAttempts: '${var.RemediationExecutionControls["MaximumAutomaticAttempts"]}'
      RetryAttemptSeconds: '${var.RemediationExecutionControls["RetryAttemptSeconds"]}'
EOT

  depends_on = [module.TagRemediationAutomationRole, module.bucket, module.lambda_custom_config_required_tags]

}
