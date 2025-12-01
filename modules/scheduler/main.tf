# ==============================================================================
# Cloud Scheduler Module
# Creates scheduled jobs to trigger Cloud Run services
# ==============================================================================

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.65.0"
    }
  }
}

# ------------------------------------------------------------------------------
# Cloud Scheduler Job
# ------------------------------------------------------------------------------
resource "google_cloud_scheduler_job" "job" {
  name        = var.name
  project     = var.project_id
  region      = var.region
  description = var.description
  schedule    = var.schedule
  time_zone   = var.time_zone

  retry_config {
    retry_count          = var.retry_count
    max_retry_duration   = var.max_retry_duration
    min_backoff_duration = var.min_backoff_duration
    max_backoff_duration = var.max_backoff_duration
    max_doublings        = var.max_doublings
  }

  http_target {
    uri         = var.target_url
    http_method = var.http_method
    body        = var.http_body != "" ? base64encode(var.http_body) : null

    headers = var.http_headers

    # OIDC token for Cloud Run authentication
    oidc_token {
      service_account_email = var.service_account_email
      audience              = var.target_url
    }
  }

  attempt_deadline = var.attempt_deadline
}

