# KMS Module

Creates Google Cloud KMS key rings and crypto keys for encryption.

## Usage

```hcl
module "kms" {
  source = "./modules/kms"

  project_id = "my-gcp-project"
  region     = "us-central1"
  key_ring   = "my-keyring"
  key_name   = "my-key"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| key_ring | Key ring name | `string` | n/a | yes |
| key_name | Crypto key name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| key_ring_id | ID of the key ring |
| key_id | ID of the crypto key |
| key_ring_name | Name of the key ring |

## Use Cases

- Encrypting secrets in Secret Manager
- Encrypting data in Cloud Storage
- Encrypting database backups
- SOPS secrets encryption

