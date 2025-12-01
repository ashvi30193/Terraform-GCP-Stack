output "secret_ids" {
  description = "Map of secret names to their Secret Manager IDs"
  value       = { for k, v in google_secret_manager_secret.secrets : k => v.id }
}

output "secret_names" {
  description = "Map of secret names to their full secret names"
  value       = { for k, v in google_secret_manager_secret.secrets : k => v.secret_id }
}

output "secret_versions" {
  description = "Map of secret names to their version names"
  value       = { for k, v in google_secret_manager_secret_version.versions : k => v.name }
}

