profile                 = "DEMO2" #account name, do not change
bucket_name             = "tag-conformance-pack-files-demo2-qa"
create_tf_backend          = true
region                  = "us-east-1"
application_domain_path = "./accounts/demo_account_2/application-domain.json"
script_path = "./src"
custom_lambda_script = "custom-required-tags-evaluation.py"
create_event_bridge_tagger = true
event_bridge_tagger_script = "event_bridge_tagger.py"
ssm_script = "ssmDocumentAutomation.py"
tags = {
  application = "config"
  domain      = "infrastructure"
  board       = "demo"
  company     = "company"
  shared      = "no"
  env         = "qa"
  tag_created = "iac"
}
RemediationExecutionControls = {
  ExecutionControls = {
    SsmControls = {
      ConcurrentExecutionRatePercentage = 20
      ErrorPercentage                   = 40
    }
  }
  Automatic                = false
  MaximumAutomaticAttempts = 1
  RetryAttemptSeconds      = 1200
}

# supported resources for required-tags managed config rule
# https://docs.aws.amazon.com/config/latest/developerguide/required-tags.html
resource_types = [
  "AWS::EC2::Instance",
]

# all supporter resources
# https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html
custom_lambda_resource_types = [
  "AWS::ECS::Cluster",
  "AWS::ECS::Cluster",
  "AWS::ECS::TaskDefinition",
  "AWS::ECS::Service",
  "AWS::ECS::TaskSet",
  "AWS::ECS::CapacityProvider",

]
  
