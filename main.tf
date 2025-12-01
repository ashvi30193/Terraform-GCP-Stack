# ==============================================================================
# Root Module - Example Usage
# ==============================================================================
# This is an example of how to use the modules together.
# Copy and customize for your own infrastructure.
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

# ==============================================================================
# Cloud Run Services
# ==============================================================================

module "cloud_run" {
  source = "./modules/cloud_run"

  for_each = var.services

  project_id   = var.project_id
  region       = var.region
  service_name = each.key
  image        = each.value.image

  cpu             = each.value.cpu
  memory          = each.value.memory
  min_instances   = each.value.min_instances
  max_instances   = each.value.max_instances
  env_vars        = each.value.env_vars
  service_account = "default"
  network         = "default"
  subnet          = "default"
}


