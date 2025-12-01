# IAM Service Account Module

Creates and manages Google Cloud service accounts with IAM bindings.

## Usage

```hcl
module "service_account" {
  source = "./modules/iam_service_account"

  project_id       = "my-gcp-project"
  account_id       = "my-service-account"
  display_name     = "My Service Account"
  description      = "Service account for my application"

  roles = [
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| account_id | Service account ID | `string` | n/a | yes |
| display_name | Display name | `string` | `""` | no |
| description | Description | `string` | `""` | no |
| roles | List of IAM roles to assign | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_account_email | Email of the service account |
| service_account_id | ID of the service account |

