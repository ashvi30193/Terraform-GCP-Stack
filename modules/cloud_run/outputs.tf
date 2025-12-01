output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloud_run.name
}

output "service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloud_run.id
}

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloud_run.uri
}

# Legacy outputs for backward compatibility
output "cloud_run_name" {
  description = "Name of the Cloud Run service (legacy)"
  value       = google_cloud_run_v2_service.cloud_run.name
}

output "cloud_run_id" {
  description = "ID of the Cloud Run service (legacy)"
  value       = google_cloud_run_v2_service.cloud_run.id
}

output "cloud_run_url" {
  description = "URL of the Cloud Run service (legacy)"
  value       = google_cloud_run_v2_service.cloud_run.uri
}
