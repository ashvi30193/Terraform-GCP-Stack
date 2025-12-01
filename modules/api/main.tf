# ==============================================================================
# API Module
# Enables GCP APIs and manages API keys
# ==============================================================================

# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset(var.apis_to_enable)

  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Create API key (if enabled)
resource "google_apikeys_key" "api_key" {
  count = var.create_api_key ? 1 : 0

  name         = var.api_key_name
  display_name = var.api_key_display_name
  project      = var.project_id

  restrictions {
    # API restrictions
    dynamic "api_targets" {
      for_each = var.api_key_restrictions
      content {
        service = api_targets.value.service
        methods = try(api_targets.value.methods, [])
      }
    }

    # Browser key restrictions (HTTP referrers)
    dynamic "browser_key_restrictions" {
      for_each = length(var.api_key_allowed_referrers) > 0 ? [1] : []
      content {
        allowed_referrers = var.api_key_allowed_referrers
      }
    }

    # Server key restrictions (IP addresses)
    dynamic "server_key_restrictions" {
      for_each = length(var.api_key_allowed_ips) > 0 ? [1] : []
      content {
        allowed_ips = var.api_key_allowed_ips
      }
    }
  }

  depends_on = [google_project_service.apis]
}

# Store API key in Secret Manager (if created)
resource "google_secret_manager_secret" "api_key_secret" {
  count = var.create_api_key && var.store_key_in_secret_manager ? 1 : 0

  secret_id = "${var.api_key_name}-secret"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "api_key_version" {
  count = var.create_api_key && var.store_key_in_secret_manager ? 1 : 0

  secret      = google_secret_manager_secret.api_key_secret[0].id
  secret_data = google_apikeys_key.api_key[0].key_string
}


