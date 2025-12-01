# Budget Alerts Module

Creates budget alerts to monitor and control cloud spending with configurable thresholds.

## Usage

```hcl
module "budget_alerts" {
  source = "./modules/budget_alerts"

  project_id         = "my-gcp-project"
  project_name       = "My Project"
  environment        = "production"
  billing_account_id = "XXXXXX-XXXXXX-XXXXXX"
  budget_amount      = 1000
  currency           = "USD"

  alert_thresholds = [50, 80, 90, 100, 120]
  notification_emails = ["admin@example.com"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| billing_account_id | Billing account ID | `string` | `""` | no |
| budget_amount | Monthly budget amount | `number` | `1000` | no |
| currency | Currency code | `string` | `"USD"` | no |
| alert_thresholds | Alert threshold percentages | `list(number)` | `[50, 80, 90, 100]` | no |
| notification_emails | Email addresses for alerts | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| project_budget_id | ID of the project budget |
| notification_channel_ids | IDs of notification channels |

## Features

- Multiple alert thresholds (e.g., 50%, 80%, 90%, 100%)
- Email notifications
- Service-specific budgets (optional)
- Forecasted spend alerts

