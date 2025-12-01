# ==============================================================================
# Example: Cloud Run with Load Balancer
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.65.0"
    }
  }
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

# Cloud Run Service
module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id   = var.project_id
  region       = var.region
  service_name = "example-service"
  image        = "gcr.io/cloudrun/hello"

  cpu           = "1"
  memory        = "512Mi"
  min_instances = 1
  max_instances = 10

  env_vars = {
    ENVIRONMENT = "production"
  }

  service_account = "default"
  network         = "default"
  subnet          = "default"
}

# Internal Load Balancer
module "load_balancer" {
  source = "../../modules/internal_lb"

  project_id      = var.project_id
  region          = var.region
  service_name    = "example-service"
  backend_service = module.cloud_run.service_name

  # SSL Certificate (must exist or be created separately)
  ssl_certificate = "projects/${var.project_id}/global/sslCertificates/example-cert"
  domain_name     = "example-service.example.com"
}

# Outputs
output "service_url" {
  description = "URL of the Cloud Run service"
  value       = module.cloud_run.service_url
}

output "load_balancer_ip" {
  description = "Internal IP of the load balancer"
  value       = module.load_balancer.load_balancer_ip
}

