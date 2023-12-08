output "mq_configuration_id" {
  value = aws_mq_configuration._.id
}

output "mq_configuration_arn" {
  value = aws_mq_configuration._.arn
}

output "mq_broker_id" {
  value = aws_mq_broker._.id
}

output "mq_bloker_arn" {
  value = aws_mq_broker._.arn

}
