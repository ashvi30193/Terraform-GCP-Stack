# Cloud Run with Load Balancer Example

This example demonstrates deploying a Cloud Run service behind an internal HTTPS load balancer.

## Prerequisites

- SSL Certificate created in GCP Certificate Manager or Compute Engine
- VPC network configured
- DNS zone configured (optional, for domain name)

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

- `service_url`: Direct URL of the Cloud Run service
- `load_balancer_ip`: Internal IP address of the load balancer

## Notes

- The SSL certificate must exist before applying
- Update `ssl_certificate` variable with your certificate resource path
- Configure DNS to point to the load balancer IP if using domain name

