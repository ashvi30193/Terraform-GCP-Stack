# Cloud Run Module

Deploys a Cloud Run service with auto-scaling, health checks, and environment variables.

## Usage

```hcl
module "cloud_run" {
  source = "./modules/cloud_run"

  project_id   = "my-gcp-project"
  region       = "us-central1"
  service_name = "my-service"
  image        = "gcr.io/my-project/my-service:latest"

  cpu             = "2"
  memory          = "1Gi"
  min_instances   = 1
  max_instances   = 10

  env_vars = {
    ENV = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| service_name | Name of the Cloud Run service | `string` | n/a | yes |
| image | Container image URL | `string` | n/a | yes |
| cpu | CPU allocation | `string` | `"1"` | no |
| memory | Memory allocation | `string` | `"512Mi"` | no |
| min_instances | Minimum instances | `number` | `0` | no |
| max_instances | Maximum instances | `number` | `10` | no |
| env_vars | Environment variables | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_url | URL of the Cloud Run service |
| service_name | Name of the Cloud Run service |

## Requirements

- Terraform >= 1.5.0
- Google Provider >= 4.65.0

