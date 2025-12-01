# ==============================================================================
# Cloud Run Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Container image URL"
  type        = string
}

variable "cpu" {
  description = "CPU allocation (e.g., '1', '2', '4')"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocation (e.g., '512Mi', '1Gi', '2Gi')"
  type        = string
  default     = "512Mi"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 100
}

variable "env_vars" {
  description = "Environment variables (non-secret)"
  type        = map(string)
  default     = {}
}

variable "secret_env_vars" {
  description = "Secret environment variables from Secret Manager"
  type = map(object({
    secret_name = string
    version     = string
  }))
  default = {}
}

variable "service_account" {
  description = "Service account email"
  type        = string
}

variable "network" {
  description = "VPC network"
  type        = string
}

variable "subnet" {
  description = "VPC subnet"
  type        = string
}

variable "ingress" {
  description = "Ingress traffic setting"
  type        = string
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

variable "execution_env" {
  description = "Execution environment"
  type        = string
  default     = "EXECUTION_ENVIRONMENT_GEN2"
}

variable "vpc_egress" {
  description = "VPC egress setting"
  type        = string
  default     = "ALL_TRAFFIC"
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access"
  type        = bool
  default     = false
}

variable "startup_timeout" {
  description = "Startup timeout in seconds (how long to wait for container to start)"
  type        = number
  default     = 120
}

variable "container_concurrency" {
  description = "Maximum number of concurrent requests per container instance"
  type        = number
  default     = 80
}

variable "request_timeout" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}
