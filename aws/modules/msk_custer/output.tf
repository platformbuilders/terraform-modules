output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk_cluster.arn
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = module.msk_cluster.bootstrap_brokers
}

output "bootstrap_brokers_plaintext" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT`"
  value       = module.msk_cluster.bootstrap_brokers_plaintext
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH`"
  value       = module.msk_cluster.current_version
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically"
  value       = module.msk_cluster.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphbetically"
  value       = module.msk_cluster.zookeeper_connect_string_tls
}

output "scram_secret_association_secret_arn_list" {
  value = module.msk_cluster.bootstrap_brokers_sasl_scram
}

output "security_group_id" {
  value = module.broker_security_group.security_group_id
}

output "secrets_arn" {
  value = module.secrets_manager.secret_arn
}