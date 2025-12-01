# Cloud Build Module

Sets up Cloud Build triggers for automated CI/CD pipelines.

## Usage

```hcl
module "cloud_build" {
  source = "./modules/cloud_build"

  project_id    = "my-gcp-project"
  region        = "us-central1"
  service_name  = "my-service"
  service_dir   = "services/my-service"
  dockerfile_path = "Dockerfile"
  tag_pattern   = "^my-service-.*"

  gitlab_project = {
    url        = "https://gitlab.com/my-org/my-repo"
    id         = "my-org/my-repo"
    branch     = "main"
    connection = "gitlab-connection"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| service_name | Name of the service | `string` | n/a | yes |
| service_dir | Directory containing Dockerfile | `string` | n/a | yes |
| dockerfile_path | Path to Dockerfile | `string` | n/a | yes |
| tag_pattern | Git tag pattern to trigger builds | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| trigger_id | ID of the Cloud Build trigger |
| trigger_name | Name of the Cloud Build trigger |

