# Cloud Scheduler Module

Creates scheduled jobs to trigger Cloud Run services or HTTP endpoints.

## Usage

```hcl
module "scheduler" {
  source = "./modules/scheduler"

  name        = "my-scheduled-job"
  project_id  = "my-gcp-project"
  region      = "us-central1"
  schedule    = "*/15 * * * *"  # Every 15 minutes
  target_url  = module.cloud_run.service_url
  http_method = "POST"
  http_body   = "{\"action\": \"process\"}"

  service_account_email = "scheduler@my-project.iam.gserviceaccount.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the scheduler job | `string` | n/a | yes |
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| schedule | Cron schedule expression | `string` | n/a | yes |
| target_url | URL to invoke | `string` | n/a | yes |
| service_account_email | Service account for OIDC auth | `string` | n/a | yes |
| http_method | HTTP method | `string` | `"POST"` | no |
| http_body | HTTP request body (JSON string) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| job_id | ID of the scheduler job |
| job_name | Name of the scheduler job |

