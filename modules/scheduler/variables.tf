# ==============================================================================
# Cloud Scheduler Module - Variables
# ==============================================================================

variable "name" {
  description = "Name of the Cloud Scheduler job"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the scheduler job"
  type        = string
}

variable "description" {
  description = "Description of the scheduler job"
  type        = string
  default     = ""
}

variable "schedule" {
  description = "Cron schedule expression (e.g., '*/15 * * * *' for every 15 minutes)"
  type        = string
}

variable "time_zone" {
  description = "Time zone for the schedule (e.g., 'Europe/Berlin')"
  type        = string
  default     = "Europe/Berlin"
}

variable "target_url" {
  description = "URL to invoke (Cloud Run service URL)"
  type        = string
}

variable "http_method" {
  description = "HTTP method (GET, POST, PUT, DELETE, etc.)"
  type        = string
  default     = "POST"
}

variable "http_body" {
  description = "HTTP request body (JSON string)"
  type        = string
  default     = ""
}

variable "http_headers" {
  description = "HTTP headers to send with the request"
  type        = map(string)
  default = {
    "Content-Type" = "application/json"
  }
}

variable "service_account_email" {
  description = "Service account email for OIDC authentication"
  type        = string
}

variable "attempt_deadline" {
  description = "The deadline for job attempts (e.g., '540s' for 9 minutes)"
  type        = string
  default     = "540s"
}

# ------------------------------------------------------------------------------
# Retry Configuration
# ------------------------------------------------------------------------------

variable "retry_count" {
  description = "Number of retry attempts for failed jobs"
  type        = number
  default     = 3
}

variable "max_retry_duration" {
  description = "Maximum duration for retries (e.g., '3600s' for 1 hour)"
  type        = string
  default     = "3600s"
}

variable "min_backoff_duration" {
  description = "Minimum backoff duration between retries"
  type        = string
  default     = "5s"
}

variable "max_backoff_duration" {
  description = "Maximum backoff duration between retries"
  type        = string
  default     = "300s"
}

variable "max_doublings" {
  description = "Maximum number of times backoff duration is doubled"
  type        = number
  default     = 5
}

