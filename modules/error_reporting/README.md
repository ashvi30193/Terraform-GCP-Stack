# Error Reporting Module

Configures Cloud Error Reporting for automatic error detection, grouping, and alerting.

## Usage

```hcl
module "error_reporting" {
  source = "./modules/error_reporting"

  project_id  = "my-gcp-project"
  environment = "production"

  services = {
    "my-service" = {
      name = "my-service"
    }
  }

  error_threshold = 10
  notification_channel_ids = [module.monitoring.notification_channel_ids[0]]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| services | Map of services to monitor | `map(object)` | `{}` | no |
| error_threshold | Errors per minute to trigger alert | `number` | `10` | no |
| notification_channel_ids | Notification channel IDs | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| error_count_metrics | Map of error count metric names |
| alert_policy_ids | Map of alert policy IDs |
| error_reporting_console_url | URL to Error Reporting console |

## Features

- Automatic error detection from Cloud Run logs
- Error rate spike alerts
- New error type detection
- BigQuery integration for error analysis (optional)

