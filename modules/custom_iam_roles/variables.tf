# ==============================================================================
# Custom IAM Roles Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Project name for role titles"
  type        = string
  default     = "My Project"
}

variable "role_prefix" {
  description = "Prefix for custom role IDs (no spaces, lowercase)"
  type        = string
  default     = "ip"
}

# ------------------------------------------------------------------------------
# Team Members
# Format: "user:email@domain.com" or "group:group@domain.com"
# ------------------------------------------------------------------------------

variable "developers" {
  description = "List of developers (user:email or group:email format)"
  type        = list(string)
  default     = []
}

variable "devops_engineers" {
  description = "List of DevOps engineers (user:email or group:email format)"
  type        = list(string)
  default     = []
}

variable "platform_admins" {
  description = "List of platform administrators (user:email or group:email format)"
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "List of viewers/stakeholders (user:email or group:email format)"
  type        = list(string)
  default     = []
}

variable "data_analysts" {
  description = "List of data analysts (user:email or group:email format)"
  type        = list(string)
  default     = []
}

