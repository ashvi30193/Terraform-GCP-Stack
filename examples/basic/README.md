# Basic Example

This example demonstrates deploying a simple Cloud Run service.

## Usage

```bash
# Initialize
terraform init

# Plan
terraform plan -var="project_id=my-gcp-project"

# Apply
terraform apply -var="project_id=my-gcp-project"
```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_id` | GCP Project ID | (required) |
| `region` | GCP Region | `us-central1` |

## Outputs

- `service_url`: URL of the deployed Cloud Run service

