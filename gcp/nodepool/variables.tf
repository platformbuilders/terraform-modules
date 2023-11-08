variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "node_pool_name" {
  description = "Node pool name"
}

variable "cluster_name" {
  description = "GKE cluster name"
}

variable "master_location" {
  description = "Master Region or Zone"
}

variable "machine_type" {
  description = "Node machine type"
}

variable "disk_size_gb" {
  description = "Node root disk size"
  default     = "100"
}

variable "initial_node_count" {
  description = "Node pool initial size"
}

variable "min_node_count" {
  description = "Node pool minimum size"
}

variable "max_node_count" {
  description = "Node pool maximum size"
}
