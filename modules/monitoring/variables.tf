# ==============================================================================
# Monitoring Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for display in dashboards and resources"
  type        = string
  default     = "My Project"
}

variable "region" {
  description = "GCP region"
  type        = string
}

# ------------------------------------------------------------------------------
# Cloud Run Services Configuration
# ------------------------------------------------------------------------------

variable "cloud_run_services" {
  description = "Map of Cloud Run services to monitor"
  type = map(object({
    name              = string
    url               = optional(string, "")
    health_check_path = optional(string, "")
    min_instances     = optional(number, 0)
  }))
  default = {}
}

# ------------------------------------------------------------------------------
# Notification Channels
# ------------------------------------------------------------------------------

variable "notification_emails" {
  description = "List of email addresses for alert notifications"
  type        = list(string)
  default     = []
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for notifications (optional)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "slack_channel_name" {
  description = "Slack channel name for notifications"
  type        = string
  default     = "#alerts"
}

variable "pagerduty_service_key" {
  description = "PagerDuty service key for notifications (optional)"
  type        = string
  default     = ""
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Alert Thresholds
# ------------------------------------------------------------------------------

variable "latency_threshold_ms" {
  description = "P99 latency threshold in milliseconds for alerts"
  type        = number
  default     = 2000 # 2 seconds
}

variable "error_rate_threshold" {
  description = "Error rate threshold (percentage) for alerts"
  type        = number
  default     = 5 # 5%
}

variable "cpu_threshold_percent" {
  description = "CPU utilization threshold (percentage) for alerts"
  type        = number
  default     = 80
}

variable "memory_threshold_percent" {
  description = "Memory utilization threshold (percentage) for alerts"
  type        = number
  default     = 85
}

# ------------------------------------------------------------------------------
# Budget Configuration
# ------------------------------------------------------------------------------

variable "billing_account_id" {
  description = "Billing account ID for budget alerts"
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget amount (0 to disable)"
  type        = number
  default     = 0
}

variable "budget_currency" {
  description = "Currency code for budget (e.g., USD, EUR)"
  type        = string
  default     = "EUR"
}

# ------------------------------------------------------------------------------
# Logging Configuration
# ------------------------------------------------------------------------------

variable "log_sink_dataset" {
  description = "BigQuery dataset for log sink (empty to disable)"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Number of days to retain logs in Cloud Logging"
  type        = number
  default     = 30
}

# ------------------------------------------------------------------------------
# Labels
# ------------------------------------------------------------------------------

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}

