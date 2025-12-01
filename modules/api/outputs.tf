# ==============================================================================
# API Module - Outputs
# ==============================================================================

output "enabled_apis" {
  description = "List of enabled API services"
  value       = [for api in google_project_service.apis : api.service]
}

output "api_key_id" {
  description = "ID of the created API key"
  value       = var.create_api_key ? google_apikeys_key.api_key[0].id : null
}

output "api_key_name" {
  description = "Name of the created API key"
  value       = var.create_api_key ? google_apikeys_key.api_key[0].name : null
}

output "api_key_string" {
  description = "The API key string (sensitive)"
  value       = var.create_api_key ? google_apikeys_key.api_key[0].key_string : null
  sensitive   = true
}

output "api_key_secret_id" {
  description = "Secret Manager secret ID containing the API key"
  value       = var.create_api_key && var.store_key_in_secret_manager ? google_secret_manager_secret.api_key_secret[0].secret_id : null
}


