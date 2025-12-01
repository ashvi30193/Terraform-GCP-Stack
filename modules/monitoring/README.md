# Monitoring Module

Comprehensive monitoring with alerts, dashboards, and uptime checks for Cloud Run services.

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  project_id = "my-gcp-project"
  
  cloud_run_services = {
    "my-service" = {
      name = "my-service"
    }
  }

  notification_emails = ["admin@example.com"]
  
  thresholds = {
    latency_ms    = 1000
    error_rate_pct = 5
    cpu_pct        = 80
    memory_pct     = 80
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| cloud_run_services | Map of Cloud Run services to monitor | `map(object)` | `{}` | no |
| notification_emails | Email addresses for alerts | `list(string)` | `[]` | no |
| latency_threshold_ms | Latency threshold in milliseconds | `number` | `1000` | no |
| error_rate_threshold_pct | Error rate threshold percentage | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| notification_channel_ids | IDs of notification channels |
| dashboard_urls | URLs to monitoring dashboards |

