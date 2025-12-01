# ==============================================================================
# Service Account Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "account_id" {
  description = "Service account ID (must be 6-30 characters, lowercase letters, digits, hyphens)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.account_id))
    error_message = "Service account ID must be 6-30 characters, start with a letter, and contain only lowercase letters, digits, and hyphens."
  }
}

variable "display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "description" {
  description = "Description of the service account"
  type        = string
  default     = ""
}

variable "project_roles" {
  description = "List of IAM roles to grant to this service account at project level"
  type        = list(string)
  default     = []
}

variable "impersonators" {
  description = "List of principals that can impersonate this service account"
  type        = list(string)
  default     = []
}

variable "token_creators" {
  description = "List of principals that can create tokens for this service account"
  type        = list(string)
  default     = []
}

variable "workload_identity_users" {
  description = "List of principals that can use this service account via Workload Identity"
  type        = list(string)
  default     = []
}


