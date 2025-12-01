# ==============================================================================
# Audit Logging Module
# Configures enhanced audit logging for compliance and security
# ==============================================================================

# ------------------------------------------------------------------------------
# Project-level Audit Logging Configuration
# Enables data access audit logs for specified services
# ------------------------------------------------------------------------------
resource "google_project_iam_audit_config" "audit_config" {
  for_each = var.audit_services

  project = var.project_id
  service = each.key

  dynamic "audit_log_config" {
    for_each = each.value.log_types
    content {
      log_type         = audit_log_config.value
      exempted_members = try(each.value.exempted_members, [])
    }
  }
}

# ------------------------------------------------------------------------------
# Log Sink for Audit Logs to BigQuery
# Stores audit logs for long-term retention and analysis
# ------------------------------------------------------------------------------
resource "google_logging_project_sink" "audit_sink_bigquery" {
  count = var.audit_sink_dataset != "" ? 1 : 0

  project     = var.project_id
  name        = "audit-logs-bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${var.audit_sink_dataset}"

  filter = <<-EOT
    logName:"cloudaudit.googleapis.com"
    OR logName:"activity"
    OR logName:"data_access"
    OR protoPayload.@type="type.googleapis.com/google.cloud.audit.AuditLog"
  EOT

  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }
}

# Grant BigQuery access to audit sink
resource "google_bigquery_dataset_iam_member" "audit_sink_writer" {
  count = var.audit_sink_dataset != "" ? 1 : 0

  project    = var.project_id
  dataset_id = var.audit_sink_dataset
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.audit_sink_bigquery[0].writer_identity
}

# ------------------------------------------------------------------------------
# Log Sink for Audit Logs to GCS (Long-term Archive)
# ------------------------------------------------------------------------------
resource "google_logging_project_sink" "audit_sink_gcs" {
  count = var.audit_sink_bucket != "" ? 1 : 0

  project     = var.project_id
  name        = "audit-logs-gcs-sink"
  destination = "storage.googleapis.com/${var.audit_sink_bucket}"

  filter = <<-EOT
    logName:"cloudaudit.googleapis.com"
    OR logName:"activity"
    OR logName:"data_access"
  EOT

  unique_writer_identity = true
}

# Grant GCS access to audit sink
resource "google_storage_bucket_iam_member" "audit_sink_writer" {
  count = var.audit_sink_bucket != "" ? 1 : 0

  bucket = var.audit_sink_bucket
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.audit_sink_gcs[0].writer_identity
}

# ------------------------------------------------------------------------------
# Log-based Metrics for Security Events
# ------------------------------------------------------------------------------

# IAM Policy Changes
resource "google_logging_metric" "iam_changes" {
  project     = var.project_id
  name        = "iam-policy-changes"
  description = "Count of IAM policy changes"
  filter      = <<-EOT
    protoPayload.methodName:"SetIamPolicy"
    OR protoPayload.methodName:"setIamPolicy"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "resource_type"
      value_type  = "STRING"
      description = "Type of resource modified"
    }
  }

  label_extractors = {
    "resource_type" = "EXTRACT(protoPayload.resourceName)"
  }
}

# Service Account Key Creation
resource "google_logging_metric" "sa_key_creation" {
  project     = var.project_id
  name        = "service-account-key-creation"
  description = "Count of service account key creations"
  filter      = <<-EOT
    protoPayload.methodName="google.iam.admin.v1.CreateServiceAccountKey"
    OR protoPayload.methodName:"CreateServiceAccountKey"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

# Secret Access
resource "google_logging_metric" "secret_access" {
  project     = var.project_id
  name        = "secret-manager-access"
  description = "Count of Secret Manager secret accesses"
  filter      = <<-EOT
    protoPayload.serviceName="secretmanager.googleapis.com"
    protoPayload.methodName:"AccessSecretVersion"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "secret_name"
      value_type  = "STRING"
      description = "Name of accessed secret"
    }
  }

  label_extractors = {
    "secret_name" = "EXTRACT(protoPayload.resourceName)"
  }
}

# Firewall Rule Changes
resource "google_logging_metric" "firewall_changes" {
  project     = var.project_id
  name        = "firewall-rule-changes"
  description = "Count of firewall rule modifications"
  filter      = <<-EOT
    resource.type="gce_firewall_rule"
    protoPayload.methodName:("insert" OR "update" OR "patch" OR "delete")
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

# Cloud Run Deployment Events
resource "google_logging_metric" "cloud_run_deployments" {
  project     = var.project_id
  name        = "cloud-run-deployments"
  description = "Count of Cloud Run service deployments"
  filter      = <<-EOT
    resource.type="cloud_run_revision"
    protoPayload.methodName:"CreateService"
    OR protoPayload.methodName:"ReplaceService"
    OR protoPayload.methodName:"UpdateService"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "service_name"
      value_type  = "STRING"
      description = "Name of deployed service"
    }
  }

  label_extractors = {
    "service_name" = "EXTRACT(resource.labels.service_name)"
  }
}

# ------------------------------------------------------------------------------
# Alert Policies for Security Events
# ------------------------------------------------------------------------------

# Alert on IAM Policy Changes
resource "google_monitoring_alert_policy" "iam_changes_alert" {
  count = var.enable_security_alerts ? 1 : 0

  project      = var.project_id
  display_name = "[Security] IAM Policy Changed"
  combiner     = "OR"

  conditions {
    display_name = "IAM policy modification detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.iam_changes.name}\" AND resource.type=\"global\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  notification_channels = var.notification_channel_ids

  documentation {
    content   = "An IAM policy was modified. Review the change in Cloud Audit Logs."
    mime_type = "text/markdown"
  }

  user_labels = {
    severity = "high"
    type     = "security"
  }
}

# Alert on Service Account Key Creation
resource "google_monitoring_alert_policy" "sa_key_alert" {
  count = var.enable_security_alerts ? 1 : 0

  project      = var.project_id
  display_name = "[Security] Service Account Key Created"
  combiner     = "OR"

  conditions {
    display_name = "Service account key creation detected"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.sa_key_creation.name}\" AND resource.type=\"global\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  notification_channels = var.notification_channel_ids

  documentation {
    content   = "A new service account key was created. Verify this was authorized."
    mime_type = "text/markdown"
  }

  user_labels = {
    severity = "critical"
    type     = "security"
  }
}

# ------------------------------------------------------------------------------
# BigQuery Dataset for Audit Logs (Optional)
# ------------------------------------------------------------------------------
resource "google_bigquery_dataset" "audit_logs" {
  count = var.create_audit_dataset ? 1 : 0

  project                    = var.project_id
  dataset_id                 = var.audit_dataset_id
  friendly_name              = "Audit Logs Dataset"
  description                = "Long-term storage for audit logs"
  location                   = var.region
  delete_contents_on_destroy = false

  default_table_expiration_ms     = var.audit_log_retention_days * 24 * 60 * 60 * 1000
  default_partition_expiration_ms = var.audit_log_retention_days * 24 * 60 * 60 * 1000

  labels = {
    environment = var.environment
    purpose     = "audit-logs"
    managed_by  = "terraform"
  }
}

