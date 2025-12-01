# ==============================================================================
# Custom IAM Roles Module - Outputs
# ==============================================================================

output "developer_role_id" {
  description = "Full ID of the developer custom role"
  value       = google_project_iam_custom_role.developer.id
}

output "developer_role_name" {
  description = "Name of the developer custom role"
  value       = google_project_iam_custom_role.developer.name
}

output "devops_role_id" {
  description = "Full ID of the DevOps custom role"
  value       = google_project_iam_custom_role.devops.id
}

output "devops_role_name" {
  description = "Name of the DevOps custom role"
  value       = google_project_iam_custom_role.devops.name
}

output "platform_admin_role_id" {
  description = "Full ID of the platform admin custom role"
  value       = google_project_iam_custom_role.platform_admin.id
}

output "platform_admin_role_name" {
  description = "Name of the platform admin custom role"
  value       = google_project_iam_custom_role.platform_admin.name
}

output "viewer_role_id" {
  description = "Full ID of the viewer custom role"
  value       = google_project_iam_custom_role.viewer.id
}

output "viewer_role_name" {
  description = "Name of the viewer custom role"
  value       = google_project_iam_custom_role.viewer.name
}

output "data_analyst_role_id" {
  description = "Full ID of the data analyst custom role"
  value       = google_project_iam_custom_role.data_analyst.id
}

output "data_analyst_role_name" {
  description = "Name of the data analyst custom role"
  value       = google_project_iam_custom_role.data_analyst.name
}

# Summary of all roles
output "all_roles" {
  description = "Map of all custom role IDs"
  value = {
    developer      = google_project_iam_custom_role.developer.id
    devops         = google_project_iam_custom_role.devops.id
    platform_admin = google_project_iam_custom_role.platform_admin.id
    viewer         = google_project_iam_custom_role.viewer.id
    data_analyst   = google_project_iam_custom_role.data_analyst.id
  }
}

