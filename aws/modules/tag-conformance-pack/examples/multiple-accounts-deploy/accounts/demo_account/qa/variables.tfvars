profile                 = "DEMO" #account name, do not change
bucket_name             = "tag-conformance-pack-files-demo-qa"
create_tf_backend          = false
region                  = "us-east-1"
application_domain_path = "./accounts/demo_account/application-domain.json"
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
  Automatic                = true
  MaximumAutomaticAttempts = 1
  RetryAttemptSeconds      = 1200
}

# supported resources for required-tags managed config rule
# https://docs.aws.amazon.com/config/latest/developerguide/required-tags.html
resource_types = [
  "AWS::ACM::Certificate",
  "AWS::AutoScaling::AutoScalingGroup",
  "AWS::CodeBuild::Project",
  "AWS::DynamoDB::Table",
  "AWS::EC2::CustomerGateway",
  "AWS::EC2::Instance",
  "AWS::EC2::InternetGateway",
  "AWS::EC2::NetworkAcl",
  "AWS::EC2::NetworkInterface",
  "AWS::EC2::RouteTable",
  "AWS::EC2::SecurityGroup",
  "AWS::EC2::Subnet",
  "AWS::EC2::Volume",
  "AWS::EC2::VPC",
  "AWS::EC2::VPNConnection",
  "AWS::EC2::VPNGateway",
  "AWS::ElasticLoadBalancing::LoadBalancer",
  "AWS::ElasticLoadBalancingV2::LoadBalancer",
  "AWS::RDS::DBInstance",
  "AWS::RDS::DBSecurityGroup",
  "AWS::RDS::DBSnapshot",
  "AWS::RDS::DBSubnetGroup",
  "AWS::RDS::EventSubscription",
  "AWS::Redshift::Cluster",
  "AWS::Redshift::ClusterParameterGroup",
  "AWS::Redshift::ClusterSecurityGroup",
  "AWS::Redshift::ClusterSnapshot",
  "AWS::Redshift::ClusterSubnetGroup",
  "AWS::S3::Bucket"
]

# all supporter resources
# https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html
custom_lambda_resource_types = [
  "AWS::ECR::Repository",
  "AWS::ECR::RegistryPolicy",
  "AWS::ECR::PullThroughCacheRule",
  "AWS::ECR::PublicRepository",
  "AWS::AmazonMQ::Broker",
  "AWS::ECS::Cluster",
  "AWS::ECS::Cluster",
  "AWS::ECS::TaskDefinition",
  "AWS::ECS::Service",
  "AWS::ECS::TaskSet",
  "AWS::ECS::CapacityProvider",
  "AWS::CloudFront::Distribution",
  "AWS::CloudFront::StreamingDistribution",
  "AWS::CloudWatch::Alarm",
  "WS::CloudWatch::MetricStream",
  "AWS::OpenSearch::Domain",
  "AWS::Elasticsearch::Domain",
  "AWS::EKS::Cluster",
  "AWS::EKS::FargateProfile",
  "AWS::EKS::IdentityProviderConfig",
  "AWS::EKS::Addon",
  "AWS::Lambda::Function",
  "AWS::Athena::WorkGroup",
  "AWS::Athena::DataCatalog",
  "AWS::Athena::PreparedStatement",
  "AWS::SQS::Queue",
  "AWS::SNS::Topic",
  "AWS::EMR::SecurityConfiguration",
  "AWS::Events::EventBus",
  "AWS::Events::Rule",
  "AWS::GuardDuty::Detector",
  "AWS::GuardDuty::ThreatIntelSet",
  "AWS::GuardDuty::IPSet",
  "AWS::GuardDuty::Filter",
  "AWS::MSK::Cluster",
  "AWS::MSK::Configuration",
  "AWS::KafkaConnect::Connector",
  "AWS::MSK::BatchScramSecret",
  "AWS::Backup::BackupPlan",
  "AWS::Backup::BackupSelection",
  "AWS::Backup::BackupVault",
  "AWS::Backup::RecoveryPoint",
  "AWS::Backup::ReportPlan",
  "AWS::NetworkManager::TransitGatewayRegistration",
  "AWS::NetworkManager::GlobalNetwork",
  "AWS::NetworkManager::CustomerGatewayAssociation",
  "AWS::SecretsManager::Secret",
  "AWS::ApiGatewayV2::Api",
  "AWS::ApiGateway::RestApi",
  "AWS::Cloud9::EnvironmentEC2",
  "AWS::CloudTrail::Trail"
]
  
