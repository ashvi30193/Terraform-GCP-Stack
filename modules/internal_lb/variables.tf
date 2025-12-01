# ==============================================================================
# Internal Load Balancer Module - Variables
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
  description = "Cloud Run service name"
  type        = string
}

variable "neg_name" {
  description = "Network Endpoint Group name"
  type        = string
}

variable "backend_service_name" {
  description = "Backend service name"
  type        = string
}

variable "url_map_name" {
  description = "URL map name"
  type        = string
}

variable "gcp_url" {
  description = "GCP API base URL"
  type        = string
  default     = "https://www.googleapis.com/compute/v1"
}

variable "network" {
  description = "VPC network"
  type        = string
}

variable "subnet" {
  description = "VPC subnet"
  type        = string
}

variable "shared_vpc_project" {
  description = "Shared VPC host project"
  type        = string
}

variable "ssl_certificate" {
  description = "SSL certificate self-link for HTTPS (e.g., projects/PROJECT/regions/REGION/sslCertificates/NAME). If null, uses HTTP."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy self-link for TLS configuration"
  type        = string
  default     = null
}
