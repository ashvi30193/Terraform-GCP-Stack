variable "service_name" {
  description = "Name of the service being built"
  type        = string
}

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

# ------------------------------------------------------------------------------
# GitLab Configuration
# ------------------------------------------------------------------------------
variable "gitlab_project_id" {
  description = "GitLab project ID"
  type        = string
}

variable "branch" {
  description = "Git branch to build from"
  type        = string
}

variable "gitlab_repo_id" {
  description = "Full Cloud Build GitLab repository resource path"
  type        = string
}

# ------------------------------------------------------------------------------
# Artifact Registry
# ------------------------------------------------------------------------------
variable "artifact_registry_url" {
  description = "Full URL of the Artifact Registry"
  type        = string
}

variable "artifact_registry_repo" {
  description = "Artifact Registry repository name"
  type        = string
}

variable "artifact_registry_name" {
  description = "Artifact Registry repository name for IAM binding"
  type        = string
}

# ------------------------------------------------------------------------------
# Docker Image
# ------------------------------------------------------------------------------
variable "image_name" {
  description = "Docker image name"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
}

variable "image_repo" {
  description = "Full Docker image repository path"
  type        = string
}

# ------------------------------------------------------------------------------
# Service Accounts
# ------------------------------------------------------------------------------
variable "service_account" {
  description = "Service account email for runtime"
  type        = string
}

variable "service_account_cloud_build" {
  description = "Full service account path for Cloud Build"
  type        = string
}

# ------------------------------------------------------------------------------
# Cloud Build Configuration
# ------------------------------------------------------------------------------
variable "service_dir" {
  description = "Directory containing the service source code"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run service to deploy"
  type        = string
}

variable "build_timeout" {
  description = "Cloud Build timeout"
  type        = string
  default     = "1800s"
}

# ------------------------------------------------------------------------------
# Secrets (from Secrets module)
# ------------------------------------------------------------------------------
variable "secret_env_vars" {
  description = "Map of environment variable names to secret version names (from Secrets module output)"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Optional/Legacy Variables
# ------------------------------------------------------------------------------
variable "frontend_env" {
  description = "Environment variables for frontend (legacy)"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Tag Trigger Configuration
# ------------------------------------------------------------------------------
variable "tag_pattern" {
  description = "Git tag pattern to trigger builds (e.g., 'frontend-.*' for frontend-v1.0.0)"
  type        = string
  default     = ".*"
}

variable "dockerfile_path" {
  description = "Path to Dockerfile relative to service_dir (default: Dockerfile)"
  type        = string
  default     = "Dockerfile"
}

# ------------------------------------------------------------------------------
# Cloud Run Configuration
# ------------------------------------------------------------------------------
variable "cloud_run_service_account" {
  description = "Service account for Cloud Run service"
  type        = string
}

variable "cloud_run_env_vars" {
  description = "Environment variables to pass to Cloud Run service"
  type        = map(string)
  default     = {}
}
