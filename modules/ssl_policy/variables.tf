# ==============================================================================
# SSL Policy Variables
# ==============================================================================

variable "name" {
  description = "Name of the SSL policy"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for regional SSL policy (null for global)"
  type        = string
  default     = null
}

variable "profile" {
  description = "SSL policy profile (COMPATIBLE, MODERN, RESTRICTED, or CUSTOM)"
  type        = string
  default     = "MODERN"

  validation {
    condition     = contains(["COMPATIBLE", "MODERN", "RESTRICTED", "CUSTOM"], var.profile)
    error_message = "Profile must be COMPATIBLE, MODERN, RESTRICTED, or CUSTOM."
  }
}

variable "min_tls_version" {
  description = "Minimum TLS version (TLS_1_0, TLS_1_1, TLS_1_2)"
  type        = string
  default     = "TLS_1_2"

  validation {
    condition     = contains(["TLS_1_0", "TLS_1_1", "TLS_1_2"], var.min_tls_version)
    error_message = "Minimum TLS version must be TLS_1_0, TLS_1_1, or TLS_1_2."
  }
}

variable "custom_features" {
  description = "Custom cipher suites (only used when profile is CUSTOM)"
  type        = list(string)
  default     = []
}

