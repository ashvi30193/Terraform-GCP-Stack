# ==============================================================================
# Error Reporting Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "services" {
  description = "Map of Cloud Run services to monitor for errors"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "error_threshold" {
  description = "Number of errors per minute to trigger alert"
  type        = number
  default     = 10
}

variable "notification_channel_ids" {
  description = "List of notification channel IDs for alerts"
  type        = list(string)
  default     = []
}

variable "enable_new_error_detection" {
  description = "Enable detection of new error types"
  type        = bool
  default     = true
}

variable "error_sink_dataset" {
  description = "BigQuery dataset ID for error logs (empty to disable)"
  type        = string
  default     = ""
}

