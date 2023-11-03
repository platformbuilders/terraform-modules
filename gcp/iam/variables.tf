variable "project_id" {
  type        = string
  description = "The project ID to manage"
}

variable "id" {
  type        = string
  description = "The Role ID to manage"
}

variable "title" {
  type        = string
  description = "Role Title"
}

variable "description" {
  type        = string
  description = "Role description"
}

variable "permissions" {
  type        = list(string)
  description = "List of permissions"
}