# ==============================================================================
# Budget Alerts Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Project name for budget display name"
  type        = string
  default     = "My Project"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID (format: XXXXXX-XXXXXX-XXXXXX). Leave empty to disable."
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget amount"
  type        = number
  default     = 1000
}

variable "currency" {
  description = "Currency code (EUR, USD, etc.)"
  type        = string
  default     = "EUR"
}

variable "alert_thresholds" {
  description = "List of threshold percentages for current spend alerts"
  type        = list(number)
  default     = [50, 80, 90, 100, 120]
}

variable "forecast_thresholds" {
  description = "List of threshold percentages for forecasted spend alerts"
  type        = list(number)
  default     = [100, 120]
}

variable "notification_emails" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
  default     = []
}

variable "notification_channel_ids" {
  description = "List of existing notification channel IDs"
  type        = list(string)
  default     = []
}

variable "pubsub_topic_id" {
  description = "Pub/Sub topic ID for programmatic budget alerts"
  type        = string
  default     = ""
}

variable "custom_period_start" {
  description = "Custom budget period start date (YYYY-MM-DD). Leave empty for monthly."
  type        = string
  default     = ""
}

variable "custom_period_end" {
  description = "Custom budget period end date (YYYY-MM-DD). Leave empty for monthly."
  type        = string
  default     = ""
}

variable "service_budgets" {
  description = "Map of service-specific budgets"
  type = map(object({
    amount   = number
    services = list(string)
  }))
  default = {}
  # Example:
  # {
  #   "cloud_run" = {
  #     amount   = 500
  #     services = ["services/run.googleapis.com"]
  #   }
  #   "bigquery" = {
  #     amount   = 200
  #     services = ["services/bigquery.googleapis.com"]
  #   }
  # }
}

