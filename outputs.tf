# ==============================================================================
# Root Module Outputs
# ==============================================================================

output "service_urls" {
  description = "URLs of deployed Cloud Run services"
  value = {
    for k, v in module.cloud_run : k => v.service_url
  }
}

output "service_names" {
  description = "Names of deployed Cloud Run services"
  value = {
    for k, v in module.cloud_run : k => v.service_name
  }
}

