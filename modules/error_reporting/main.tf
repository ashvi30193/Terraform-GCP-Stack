# ==============================================================================
# Error Reporting Module
# Configures Cloud Error Reporting for automatic error detection and grouping
# ==============================================================================

# ------------------------------------------------------------------------------
# Enable Error Reporting API
# ------------------------------------------------------------------------------
resource "google_project_service" "error_reporting" {
  project            = var.project_id
  service            = "clouderrorreporting.googleapis.com"
  disable_on_destroy = false
}

# ------------------------------------------------------------------------------
# Log-based Metric for Error Detection
# Captures errors from Cloud Run services
# ------------------------------------------------------------------------------
resource "google_logging_metric" "error_count" {
  for_each = var.services

  project     = var.project_id
  name        = "${each.key}-error-count"
  description = "Count of errors from ${each.key} service"
  filter      = <<-EOT
    resource.type="cloud_run_revision"
    resource.labels.service_name="${each.key}"
    severity>=ERROR
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "severity"
      value_type  = "STRING"
      description = "Error severity level"
    }
  }

  label_extractors = {
    "severity" = "EXTRACT(severity)"
  }
}

# ------------------------------------------------------------------------------
# Log-based Metric for Exception Tracking
# Captures stack traces and exceptions
# ------------------------------------------------------------------------------
resource "google_logging_metric" "exception_count" {
  for_each = var.services

  project     = var.project_id
  name        = "${each.key}-exception-count"
  description = "Count of exceptions from ${each.key} service"
  filter      = <<-EOT
    resource.type="cloud_run_revision"
    resource.labels.service_name="${each.key}"
    (textPayload=~"(?i)(exception|traceback|error|failed)"
     OR jsonPayload.message=~"(?i)(exception|traceback|error|failed)"
     OR jsonPayload.error=~".*")
    severity>=WARNING
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

# ------------------------------------------------------------------------------
# Alert Policy for Error Rate Spike
# Triggers when error rate exceeds threshold
# ------------------------------------------------------------------------------
resource "google_monitoring_alert_policy" "error_rate_spike" {
  for_each = var.services

  project      = var.project_id
  display_name = "[${each.key}] Error Rate Spike"
  combiner     = "OR"

  conditions {
    display_name = "Error count exceeds threshold"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.error_count[each.key].name}\" AND resource.type=\"cloud_run_revision\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.error_threshold

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channel_ids

  alert_strategy {
    auto_close = "1800s" # 30 minutes
  }

  documentation {
    content   = "Error rate spike detected for ${each.key}. Check Cloud Logging for details: https://console.cloud.google.com/logs/query;query=resource.type%3D%22cloud_run_revision%22%0Aresource.labels.service_name%3D%22${each.key}%22%0Aseverity%3E%3DERROR"
    mime_type = "text/markdown"
  }

  user_labels = {
    service     = each.key
    environment = var.environment
    severity    = "high"
  }
}

# ------------------------------------------------------------------------------
# Alert Policy for New Error Types
# Detects when new types of errors appear
# ------------------------------------------------------------------------------
resource "google_monitoring_alert_policy" "new_errors" {
  count = var.enable_new_error_detection ? 1 : 0

  project      = var.project_id
  display_name = "[All Services] New Error Types Detected"
  combiner     = "OR"

  conditions {
    display_name = "New error types in logs"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/log_entry_count\" AND resource.type=\"cloud_run_revision\" AND metric.labels.severity=\"ERROR\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  notification_channels = var.notification_channel_ids

  documentation {
    content   = "New error types detected across services. Review in Error Reporting: https://console.cloud.google.com/errors?project=${var.project_id}"
    mime_type = "text/markdown"
  }

  user_labels = {
    environment = var.environment
    severity    = "medium"
  }
}

# ------------------------------------------------------------------------------
# Log Sink for Error Aggregation (Optional)
# Sends errors to BigQuery for analysis
# ------------------------------------------------------------------------------
resource "google_logging_project_sink" "error_sink" {
  count = var.error_sink_dataset != "" ? 1 : 0

  project     = var.project_id
  name        = "error-reporting-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${var.error_sink_dataset}"

  filter = <<-EOT
    resource.type="cloud_run_revision"
    severity>=ERROR
  EOT

  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }
}

# Grant BigQuery access to log sink service account
resource "google_bigquery_dataset_iam_member" "error_sink_writer" {
  count = var.error_sink_dataset != "" ? 1 : 0

  project    = var.project_id
  dataset_id = var.error_sink_dataset
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.error_sink[0].writer_identity
}

