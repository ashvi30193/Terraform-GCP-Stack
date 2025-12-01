# ==============================================================================
# Audit Logging Module - Outputs
# ==============================================================================

output "audit_sink_bigquery_name" {
  description = "Name of the BigQuery audit log sink"
  value       = length(google_logging_project_sink.audit_sink_bigquery) > 0 ? google_logging_project_sink.audit_sink_bigquery[0].name : null
}

output "audit_sink_bigquery_writer" {
  description = "Service account for BigQuery audit sink"
  value       = length(google_logging_project_sink.audit_sink_bigquery) > 0 ? google_logging_project_sink.audit_sink_bigquery[0].writer_identity : null
}

output "audit_sink_gcs_name" {
  description = "Name of the GCS audit log sink"
  value       = length(google_logging_project_sink.audit_sink_gcs) > 0 ? google_logging_project_sink.audit_sink_gcs[0].name : null
}

output "audit_dataset_id" {
  description = "BigQuery dataset ID for audit logs"
  value       = length(google_bigquery_dataset.audit_logs) > 0 ? google_bigquery_dataset.audit_logs[0].dataset_id : null
}

output "security_metrics" {
  description = "Map of security log metric names"
  value = {
    iam_changes           = google_logging_metric.iam_changes.name
    sa_key_creation       = google_logging_metric.sa_key_creation.name
    secret_access         = google_logging_metric.secret_access.name
    firewall_changes      = google_logging_metric.firewall_changes.name
    cloud_run_deployments = google_logging_metric.cloud_run_deployments.name
  }
}

output "security_alert_policies" {
  description = "List of security alert policy IDs"
  value = compact([
    length(google_monitoring_alert_policy.iam_changes_alert) > 0 ? google_monitoring_alert_policy.iam_changes_alert[0].id : null,
    length(google_monitoring_alert_policy.sa_key_alert) > 0 ? google_monitoring_alert_policy.sa_key_alert[0].id : null
  ])
}

output "audit_logs_console_url" {
  description = "URL to Cloud Audit Logs console"
  value       = "https://console.cloud.google.com/logs/query;query=logName%3A%22cloudaudit.googleapis.com%22?project=${var.project_id}"
}

