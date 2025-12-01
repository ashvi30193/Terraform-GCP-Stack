# ==============================================================================
# SSL Policy Outputs
# ==============================================================================

output "name" {
  description = "Name of the SSL policy"
  value       = var.region != null ? google_compute_region_ssl_policy.default[0].name : google_compute_ssl_policy.default[0].name
}

output "self_link" {
  description = "Self link of the SSL policy"
  value       = var.region != null ? google_compute_region_ssl_policy.default[0].self_link : google_compute_ssl_policy.default[0].self_link
}

output "id" {
  description = "ID of the SSL policy"
  value       = var.region != null ? google_compute_region_ssl_policy.default[0].id : google_compute_ssl_policy.default[0].id
}

