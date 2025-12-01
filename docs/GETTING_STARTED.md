# Getting Started

This guide will help you get started with Terraform GCP Stack.

## Prerequisites

- Terraform >= 1.5.0 installed
- Google Cloud SDK installed and configured
- GCP Project with billing enabled
- Required APIs enabled

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_ORG/terraform-gcp-stack.git
cd terraform-gcp-stack
```

### 2. Enable Required APIs

```bash
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  secretmanager.googleapis.com \
  monitoring.googleapis.com
```

### 3. Initialize Terraform

```bash
terraform init
```

## Basic Usage

### Deploy a Simple Service

```hcl
module "my_service" {
  source = "./modules/cloud_run"

  project_id   = "my-gcp-project"
  region       = "us-central1"
  service_name = "my-service"
  image        = "gcr.io/my-project/my-service:latest"

  cpu             = "1"
  memory          = "512Mi"
  min_instances   = 0
  max_instances   = 10
}
```

### Deploy with Load Balancer

```hcl
module "cloud_run" {
  source = "./modules/cloud_run"
  # ... configuration
}

module "load_balancer" {
  source = "./modules/internal_lb"

  project_id      = "my-gcp-project"
  region          = "us-central1"
  service_name    = "my-service"
  backend_service = module.cloud_run.service_name
}
```

## Next Steps

- Check out [Examples](examples/) for more use cases
- Read [Module Reference](MODULES.md) for detailed documentation
- See [Contributing](CONTRIBUTING.md) to contribute

