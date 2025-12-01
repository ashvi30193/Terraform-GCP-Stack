# ==============================================================================
# BigQuery Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "datasets" {
  description = "List of BigQuery datasets to create"
  type = list(object({
    id          = string
    location    = optional(string, "EU")
    description = optional(string, "Managed by Terraform")
  }))
  default = []
}

variable "tables" {
  description = "List of tables to create (requires datasets to exist)"
  type = list(object({
    dataset = string
    name    = string
    schema  = optional(string, null) # Path to JSON schema file
  }))
  default = []
}

variable "delete_contents_on_destroy" {
  description = "Whether to delete dataset contents when destroying"
  type        = bool
  default     = false
}

variable "table_deletion_protection" {
  description = "Enable deletion protection for tables"
  type        = bool
  default     = false
}

variable "data_editor_members" {
  description = "List of members to grant BigQuery Data Editor role"
  type        = list(string)
  default     = []
}

variable "data_viewer_members" {
  description = "List of members to grant BigQuery Data Viewer role"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}
