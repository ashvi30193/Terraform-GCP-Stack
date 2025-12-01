# ==============================================================================
# Error Reporting Module - Outputs
# ==============================================================================

output "error_count_metrics" {
  description = "Map of error count log metric names"
  value       = { for k, v in google_logging_metric.error_count : k => v.name }
}

output "exception_count_metrics" {
  description = "Map of exception count log metric names"
  value       = { for k, v in google_logging_metric.exception_count : k => v.name }
}

output "alert_policy_ids" {
  description = "Map of alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.error_rate_spike : k => v.id }
}

output "error_sink_writer_identity" {
  description = "Service account for error log sink"
  value       = length(google_logging_project_sink.error_sink) > 0 ? google_logging_project_sink.error_sink[0].writer_identity : null
}

output "error_reporting_console_url" {
  description = "URL to Cloud Error Reporting console"
  value       = "https://console.cloud.google.com/errors?project=${var.project_id}"
}

