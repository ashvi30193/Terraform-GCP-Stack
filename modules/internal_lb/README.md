# Internal Load Balancer Module

Creates an internal HTTPS load balancer for Cloud Run services.

## Usage

```hcl
module "load_balancer" {
  source = "./modules/internal_lb"

  project_id      = "my-gcp-project"
  region          = "us-central1"
  service_name    = "my-service"
  backend_service = module.cloud_run.service_name

  ssl_certificate = "projects/my-project/global/sslCertificates/my-cert"
  domain_name     = "my-service.example.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| service_name | Name of the Cloud Run service | `string` | n/a | yes |
| backend_service | Backend service name | `string` | n/a | yes |
| ssl_certificate | SSL certificate resource path | `string` | n/a | yes |
| domain_name | Domain name for DNS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| load_balancer_ip | Internal IP address of the load balancer |
| forwarding_rule_name | Name of the forwarding rule |

