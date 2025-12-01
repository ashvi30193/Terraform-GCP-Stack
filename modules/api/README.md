# API Module

Enables and manages Google Cloud APIs.

## Usage

```hcl
module "apis" {
  source = "./modules/api"

  project_id = "my-gcp-project"

  apis = [
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| apis | List of API names to enable | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| enabled_apis | List of enabled API names |

