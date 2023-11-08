output "id" {
  value = google_container_node_pool._.id
}

output "name" {
  value = google_container_node_pool._.name
}

output "nodes_locations" {
  value = google_container_node_pool._.node_locations
}

output "initial_node_count" {
  value = google_container_node_pool._.initial_node_count
}

output "min_node_count" {
  value = google_container_node_pool._.autoscaling.0.min_node_count
}

output "max_node_count" {
  value = google_container_node_pool._.autoscaling.0.max_node_count
}
