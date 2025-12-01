# Secrets Module

Manages secrets in Google Cloud Secret Manager with KMS encryption.

## Usage

```hcl
module "secrets" {
  source = "./modules/secrets"

  project_id = "my-gcp-project"
  region     = "us-central1"
  
  secrets = {
    "api-key" = {
      secret_data = "my-secret-value"
      kms_key     = "projects/my-project/locations/us-central1/keyRings/my-keyring/cryptoKeys/my-key"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| secrets | Map of secrets to create | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret_names | Map of secret names |
| secret_ids | Map of secret resource IDs |

