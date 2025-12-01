variable "name" {
  description = "Name prefix for the KMS keyring and key"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the keyring"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "suffix" {
  description = "Optional suffix to append to keyring/key names (useful when keyring already exists)"
  type        = string
  default     = ""
}

variable "rotation_period" {
  description = "Rotation period for the crypto key (default: 90 days)"
  type        = string
  default     = "7776000s"
}

variable "purpose" {
  description = "The immutable purpose of the CryptoKey"
  type        = string
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT", "MAC"], var.purpose)
    error_message = "Purpose must be one of: ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, ASYMMETRIC_DECRYPT, MAC"
  }
}

variable "algorithm" {
  description = "The algorithm to use for the key (e.g., GOOGLE_SYMMETRIC_ENCRYPTION)"
  type        = string
  default     = null
}

variable "protection_level" {
  description = "The protection level for the key (SOFTWARE or HSM)"
  type        = string
  default     = "SOFTWARE"
  validation {
    condition     = contains(["SOFTWARE", "HSM"], var.protection_level)
    error_message = "Protection level must be either SOFTWARE or HSM"
  }
}

variable "labels" {
  description = "Additional labels for the KMS key"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# IAM Members
# ------------------------------------------------------------------------------
variable "encrypter_decrypter_members" {
  description = "List of members to grant encrypter/decrypter role (e.g., serviceAccount:xxx@xxx.iam.gserviceaccount.com)"
  type        = list(string)
  default     = []
}

variable "decrypter_members" {
  description = "List of members to grant decrypter role"
  type        = list(string)
  default     = []
}

variable "encrypter_members" {
  description = "List of members to grant encrypter role"
  type        = list(string)
  default     = []
}

