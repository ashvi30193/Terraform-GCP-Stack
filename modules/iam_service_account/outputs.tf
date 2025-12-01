# ==============================================================================
# Service Account Module - Outputs
# ==============================================================================

output "email" {
  description = "Email address of the service account"
  value       = google_service_account.service_account.email
}

output "name" {
  description = "Full resource name of the service account"
  value       = google_service_account.service_account.name
}

output "id" {
  description = "Unique ID of the service account"
  value       = google_service_account.service_account.unique_id
}

output "member" {
  description = "IAM member string for the service account"
  value       = "serviceAccount:${google_service_account.service_account.email}"
}

output "full_path" {
  description = "Full path for Cloud Build service account reference"
  value       = "projects/${var.project_id}/serviceAccounts/${google_service_account.service_account.email}"
}


