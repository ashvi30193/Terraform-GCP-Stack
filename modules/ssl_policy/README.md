# SSL Policy Module

Creates SSL policies for load balancers with configurable TLS settings.

## Usage

```hcl
module "ssl_policy" {
  source = "./modules/ssl_policy"

  project_id      = "my-gcp-project"
  name            = "my-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| name | Name of the SSL policy | `string` | n/a | yes |
| profile | SSL profile (COMPATIBLE, MODERN, RESTRICTED) | `string` | `"MODERN"` | no |
| min_tls_version | Minimum TLS version | `string` | `"TLS_1_2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ssl_policy_id | ID of the SSL policy |
| ssl_policy_name | Name of the SSL policy |

