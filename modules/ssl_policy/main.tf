# ==============================================================================
# SSL Policy Module
# Creates and manages SSL/TLS policies for load balancers
# Note: Regional SSL policies are needed for regional internal LBs
# ==============================================================================

# Regional SSL Policy (for regional internal load balancers)
resource "google_compute_region_ssl_policy" "default" {
  count = var.region != null ? 1 : 0

  name            = var.name
  project         = var.project_id
  region          = var.region
  profile         = var.profile
  min_tls_version = var.min_tls_version

  # Custom features (only used when profile is CUSTOM)
  custom_features = var.profile == "CUSTOM" ? var.custom_features : null
}

# Global SSL Policy (for global external load balancers)
resource "google_compute_ssl_policy" "default" {
  count = var.region == null ? 1 : 0

  name            = var.name
  project         = var.project_id
  profile         = var.profile
  min_tls_version = var.min_tls_version

  # Custom features (only used when profile is CUSTOM)
  custom_features = var.profile == "CUSTOM" ? var.custom_features : null
}

