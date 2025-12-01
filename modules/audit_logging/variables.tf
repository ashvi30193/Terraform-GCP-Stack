# ==============================================================================
# Audit Logging Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

# ------------------------------------------------------------------------------
# Audit Log Configuration
# ------------------------------------------------------------------------------

variable "audit_services" {
  description = "Map of services to enable audit logging for"
  type = map(object({
    log_types        = list(string) # ADMIN_READ, DATA_READ, DATA_WRITE
    exempted_members = optional(list(string), [])
  }))
  default = {
    "allServices" = {
      log_types = ["ADMIN_READ"]
    }
    "bigquery.googleapis.com" = {
      log_types = ["ADMIN_READ", "DATA_READ", "DATA_WRITE"]
    }
    "secretmanager.googleapis.com" = {
      log_types = ["ADMIN_READ", "DATA_READ"]
    }
    "run.googleapis.com" = {
      log_types = ["ADMIN_READ", "DATA_WRITE"]
    }
    "cloudkms.googleapis.com" = {
      log_types = ["ADMIN_READ", "DATA_READ"]
    }
    "iam.googleapis.com" = {
      log_types = ["ADMIN_READ"]
    }
  }
}

# ------------------------------------------------------------------------------
# Log Sinks
# ------------------------------------------------------------------------------

variable "audit_sink_dataset" {
  description = "BigQuery dataset ID for audit logs (empty to disable)"
  type        = string
  default     = ""
}

variable "audit_sink_bucket" {
  description = "GCS bucket name for audit log archive (empty to disable)"
  type        = string
  default     = ""
}

# ------------------------------------------------------------------------------
# BigQuery Dataset for Audit Logs
# ------------------------------------------------------------------------------

variable "create_audit_dataset" {
  description = "Create a BigQuery dataset for audit logs"
  type        = bool
  default     = false
}

variable "audit_dataset_id" {
  description = "BigQuery dataset ID for audit logs"
  type        = string
  default     = "audit_logs"
}

variable "audit_log_retention_days" {
  description = "Days to retain audit logs in BigQuery"
  type        = number
  default     = 365
}

# ------------------------------------------------------------------------------
# Security Alerts
# ------------------------------------------------------------------------------

variable "enable_security_alerts" {
  description = "Enable security alert policies"
  type        = bool
  default     = true
}

variable "notification_channel_ids" {
  description = "List of notification channel IDs for security alerts"
  type        = list(string)
  default     = []
}

