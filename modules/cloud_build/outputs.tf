output "trigger_id" {
  description = "The ID of the Cloud Build trigger"
  value       = google_cloudbuild_trigger.gitlab_trigger.id
}

output "trigger_name" {
  description = "The name of the Cloud Build trigger"
  value       = google_cloudbuild_trigger.gitlab_trigger.name
}

output "image_url" {
  description = "Full URL of the built Docker image"
  value       = "${var.artifact_registry_url}/${var.image_name}:${var.image_tag}"
}
