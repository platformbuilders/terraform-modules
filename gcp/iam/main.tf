resource "google_project_iam_custom_role" "_" {
  role_id = var.id

  project     = var.project_id
  title       = var.title
  description = var.description
  permissions = var.permissions
}
