# ==============================================================================
# API Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "apis_to_enable" {
  description = "List of GCP API services to enable"
  type        = list(string)
  default = [
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
    "pubsub.googleapis.com",
    "bigquery.googleapis.com",
    "firestore.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "certificatemanager.googleapis.com",
    "aiplatform.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

# API Key Configuration
variable "create_api_key" {
  description = "Whether to create an API key"
  type        = bool
  default     = false
}

variable "api_key_name" {
  description = "Name for the API key"
  type        = string
  default     = "default-api-key"
}

variable "api_key_display_name" {
  description = "Display name for the API key"
  type        = string
  default     = "Default API Key"
}

variable "api_key_restrictions" {
  description = "List of API restrictions for the key"
  type = list(object({
    service = string
    methods = optional(list(string), [])
  }))
  default = []
}

variable "api_key_allowed_referrers" {
  description = "List of allowed HTTP referrers for browser key"
  type        = list(string)
  default     = []
}

variable "api_key_allowed_ips" {
  description = "List of allowed IP addresses for server key"
  type        = list(string)
  default     = []
}

variable "store_key_in_secret_manager" {
  description = "Whether to store the API key in Secret Manager"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}


