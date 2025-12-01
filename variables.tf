# ==============================================================================
# Root Module Variables
# ==============================================================================

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "services" {
  description = "Map of Cloud Run services to deploy"
  type = map(object({
    image         = string
    cpu           = string
    memory        = string
    min_instances = number
    max_instances = number
    env_vars      = map(string)
  }))
  default = {}
}

