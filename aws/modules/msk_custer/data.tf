data "aws_caller_identity" "current" {}

data "aws_iam_policy" "kafka_service_policy" {
  arn = "arn:aws:iam::aws:policy/aws-service-role/KafkaServiceRolePolicy"
}

data "aws_iam_roles" "existing_roles" {}