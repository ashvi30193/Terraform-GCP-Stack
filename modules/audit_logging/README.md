# Audit Logging Module

Configures enhanced audit logging for compliance and security tracking.

## Usage

```hcl
module "audit_logging" {
  source = "./modules/audit_logging"

  project_id  = "my-gcp-project"
  environment = "production"
  region      = "us-central1"

  audit_services = {
    "allServices" = {
      log_types = ["ADMIN_READ"]
    }
    "run.googleapis.com" = {
      log_types = ["ADMIN_READ", "DATA_WRITE"]
    }
  }

  enable_security_alerts = true
  notification_channel_ids = [module.monitoring.notification_channel_ids[0]]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| audit_services | Services to enable audit logging | `map(object)` | `{}` | no |
| enable_security_alerts | Enable security alert policies | `bool` | `true` | no |
| notification_channel_ids | Notification channel IDs | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_metrics | Map of security log metric names |
| security_alert_policies | List of security alert policy IDs |
| audit_logs_console_url | URL to Audit Logs console |

## Features

- IAM policy change tracking
- Service account key creation alerts
- Secret access monitoring
- Firewall rule change tracking
- Cloud Run deployment events
- BigQuery log sink for long-term storage

