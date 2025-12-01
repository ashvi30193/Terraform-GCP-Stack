# Pub/Sub Module

Creates Pub/Sub topics and subscriptions for event-driven architectures.

## Usage

```hcl
module "pubsub" {
  source = "./modules/pubsub"

  project_id = "my-gcp-project"
  
  topics = {
    "my-topic" = {
      name = "my-topic"
    }
  }

  subscriptions = {
    "my-subscription" = {
      topic = "my-topic"
      name  = "my-subscription"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| topics | Map of topics to create | `map(object)` | `{}` | no |
| subscriptions | Map of subscriptions to create | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| topic_names | Map of topic names |
| subscription_names | Map of subscription names |

