variable "name_prefix" {
  description = "Name prefix for secrets (e.g., service name)"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (required if using KMS encryption)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

# ------------------------------------------------------------------------------
# Secrets Configuration
# ------------------------------------------------------------------------------
variable "secret_names" {
  description = "Set of secret names to create"
  type        = set(string)
  default     = []
}

variable "secret_values" {
  description = "Map of secret names to their values"
  type        = map(string)
  default     = {}
  sensitive   = true
}

# ------------------------------------------------------------------------------
# KMS Encryption (Optional)
# ------------------------------------------------------------------------------
variable "kms_crypto_key_id" {
  description = "KMS crypto key ID for customer-managed encryption (optional)"
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------
variable "accessor_members" {
  description = "List of members to grant secret accessor role"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------
# Labels
# ------------------------------------------------------------------------------
variable "labels" {
  description = "Additional labels for secrets"
  type        = map(string)
  default     = {}
}

