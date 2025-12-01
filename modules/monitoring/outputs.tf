# ==============================================================================
# Monitoring Module - Outputs
# ==============================================================================

# ------------------------------------------------------------------------------
# Notification Channels
# ------------------------------------------------------------------------------

output "notification_channel_ids" {
  description = "List of all notification channel IDs"
  value       = local.notification_channel_ids
}

output "email_notification_channels" {
  description = "Map of email addresses to notification channel IDs"
  value       = { for email, ch in google_monitoring_notification_channel.email : email => ch.id }
}

# ------------------------------------------------------------------------------
# Alert Policies
# ------------------------------------------------------------------------------

output "latency_alert_policies" {
  description = "Map of service names to latency alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.cloud_run_latency : k => v.name }
}

output "error_rate_alert_policies" {
  description = "Map of service names to error rate alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.cloud_run_error_rate : k => v.name }
}

output "cpu_alert_policies" {
  description = "Map of service names to CPU alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.cloud_run_cpu : k => v.name }
}

output "memory_alert_policies" {
  description = "Map of service names to memory alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.cloud_run_memory : k => v.name }
}

# ------------------------------------------------------------------------------
# Uptime Checks
# ------------------------------------------------------------------------------

output "uptime_check_ids" {
  description = "Map of service names to uptime check IDs"
  value       = { for k, v in google_monitoring_uptime_check_config.service_health : k => v.uptime_check_id }
}

# ------------------------------------------------------------------------------
# Log Metrics
# ------------------------------------------------------------------------------

output "app_error_metric_names" {
  description = "Map of service names to application error log metric names"
  value       = { for k, v in google_logging_metric.app_errors : k => v.name }
}

output "request_status_metric_names" {
  description = "Map of service names to request status log metric names"
  value       = { for k, v in google_logging_metric.request_by_status : k => v.name }
}

output "slow_request_metric_names" {
  description = "Map of service names to slow request log metric names"
  value       = { for k, v in google_logging_metric.slow_requests : k => v.name }
}

# ------------------------------------------------------------------------------
# Dashboards
# ------------------------------------------------------------------------------

output "cloud_run_dashboard_id" {
  description = "Cloud Run overview dashboard ID"
  value       = google_monitoring_dashboard.cloud_run_overview.id
}

output "load_balancer_dashboard_id" {
  description = "Load balancer overview dashboard ID"
  value       = google_monitoring_dashboard.load_balancer_overview.id
}

output "dashboard_urls" {
  description = "URLs to access the dashboards in GCP Console"
  value = {
    cloud_run     = "https://console.cloud.google.com/monitoring/dashboards/builder/${split("/", google_monitoring_dashboard.cloud_run_overview.id)[3]}?project=${var.project_id}"
    load_balancer = "https://console.cloud.google.com/monitoring/dashboards/builder/${split("/", google_monitoring_dashboard.load_balancer_overview.id)[3]}?project=${var.project_id}"
  }
}

# ------------------------------------------------------------------------------
# Budget
# ------------------------------------------------------------------------------

output "budget_name" {
  description = "Name of the billing budget"
  value       = var.budget_amount > 0 ? google_billing_budget.project_budget[0].display_name : null
}

# ------------------------------------------------------------------------------
# Log Sink
# ------------------------------------------------------------------------------

output "log_sink_writer_identity" {
  description = "Service account identity used by the log sink"
  value       = var.log_sink_dataset != "" ? google_logging_project_sink.bigquery_sink[0].writer_identity : null
}

