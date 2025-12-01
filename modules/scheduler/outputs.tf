# ==============================================================================
# Cloud Scheduler Module - Outputs
# ==============================================================================

output "job_name" {
  description = "Name of the Cloud Scheduler job"
  value       = google_cloud_scheduler_job.job.name
}

output "job_id" {
  description = "ID of the Cloud Scheduler job"
  value       = google_cloud_scheduler_job.job.id
}

output "schedule" {
  description = "Cron schedule of the job"
  value       = google_cloud_scheduler_job.job.schedule
}

output "state" {
  description = "Current state of the job"
  value       = google_cloud_scheduler_job.job.state
}

