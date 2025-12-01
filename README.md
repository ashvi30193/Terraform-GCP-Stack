# Terraform GCP Stack

Production-ready Terraform modules for Google Cloud Platform. Deploy Cloud Run services, Pub/Sub, BigQuery, monitoring, security, and more with integrated CI/CD, load balancers, and best practices.

[![Terraform](https://img.shields.io/badge/Terraform->=1.5.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![GCP](https://img.shields.io/badge/GCP-Cloud%20Run-4285F4?logo=google-cloud)](https://cloud.google.com/run)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

## Features

- **Modular Architecture**: Reusable, composable modules
- **Production Ready**: Load balancers, monitoring, security built-in
- **CI/CD Integration**: Cloud Build triggers for automated deployments
- **Secrets Management**: Integrated with Secret Manager and KMS
- **Monitoring**: Comprehensive alerts and dashboards
- **Cost Management**: Budget alerts and tracking
- **Security**: Audit logging, custom IAM roles, SSL/TLS

## Modules

### Core Infrastructure
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`cloud_run`](modules/cloud_run/README.md) | Deploy Cloud Run services with auto-scaling | [README](modules/cloud_run/README.md) |
| [`internal_lb`](modules/internal_lb/README.md) | Internal HTTPS load balancers | [README](modules/internal_lb/README.md) |
| [`ssl_policy`](modules/ssl_policy/README.md) | SSL policies for load balancers | [README](modules/ssl_policy/README.md) |

### CI/CD & Automation
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`cloud_build`](modules/cloud_build/README.md) | CI/CD triggers for automated builds | [README](modules/cloud_build/README.md) |
| [`scheduler`](modules/scheduler/README.md) | Cloud Scheduler for scheduled jobs | [README](modules/scheduler/README.md) |

### Security & Access
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`secrets`](modules/secrets/README.md) | Secret Manager integration | [README](modules/secrets/README.md) |
| [`kms`](modules/kms/README.md) | Key Management Service | [README](modules/kms/README.md) |
| [`iam_service_account`](modules/iam_service_account/README.md) | Service account management | [README](modules/iam_service_account/README.md) |
| [`custom_iam_roles`](modules/custom_iam_roles/README.md) | Custom IAM roles for RBAC | [README](modules/custom_iam_roles/README.md) |
| [`audit_logging`](modules/audit_logging/README.md) | Security audit trails | [README](modules/audit_logging/README.md) |

### Monitoring & Observability
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`monitoring`](modules/monitoring/README.md) | Alerts, dashboards, and uptime checks | [README](modules/monitoring/README.md) |
| [`error_reporting`](modules/error_reporting/README.md) | Error detection and tracking | [README](modules/error_reporting/README.md) |

### Data & Messaging
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`pubsub`](modules/pubsub/README.md) | Pub/Sub topics and subscriptions | [README](modules/pubsub/README.md) |
| [`bigquery`](modules/bigquery/README.md) | BigQuery datasets and tables | [README](modules/bigquery/README.md) |

### Cost Management
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`budget_alerts`](modules/budget_alerts/README.md) | Cost monitoring and alerts | [README](modules/budget_alerts/README.md) |

### Utilities
| Module | Description | Documentation |
|--------|-------------|--------------|
| [`api`](modules/api/README.md) | Enable Google Cloud APIs | [README](modules/api/README.md) |

## Quick Start

```hcl
module "cloud_run_service" {
  source = "./modules/cloud_run"

  project_id   = "my-gcp-project"
  region       = "us-central1"
  service_name = "my-service"
  image        = "gcr.io/my-project/my-service:latest"
  
  cpu    = "2"
  memory = "1Gi"
  
  min_instances = 1
  max_instances = 10
}

module "load_balancer" {
  source = "./modules/internal_lb"

  project_id      = "my-gcp-project"
  region          = "us-central1"
  service_name    = "my-service"
  backend_service = module.cloud_run_service.service_name
  
  ssl_certificate = "projects/my-project/global/sslCertificates/my-cert"
}
```

## Documentation

- [Getting Started](docs/GETTING_STARTED.md)
- [Module Reference](docs/MODULES.md)
- [Testing Guide](TESTING.md)
- [Examples](examples/)
- [Contributing](CONTRIBUTING.md)

## Testing

```bash
# Run all tests
make test

# Or use the test script
./scripts/test.sh

# Individual checks
make fmt-check      # Check formatting
make validate       # Validate modules
make lint          # Check for issues
```

See [TESTING.md](TESTING.md) for detailed testing guide.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                          TERRAFORM GCP STACK ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │                        CI/CD & AUTOMATION                                        │  │
│  │  ┌──────────────┐                    ┌──────────────┐                           │  │
│  │  │ Cloud Build  │───────────────────▶│  Scheduler   │                           │  │
│  │  │  (Triggers)  │   Build & Deploy   │  (Cron Jobs) │                           │  │
│  │  └──────┬───────┘                    └──────┬───────┘                           │  │
│  └─────────┼────────────────────────────────────┼──────────────────────────────────┘  │
│            │                                    │                                      │
│            ▼                                    ▼                                      │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │                        CORE INFRASTRUCTURE                                         │  │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                       │  │
│  │  │ Cloud Run    │◀───│ Internal LB  │◀───│  SSL Policy  │                       │  │
│  │  │ (Services)   │    │  (HTTPS)     │    │  (TLS 1.2+)  │                       │  │
│  │  └──────┬───────┘    └──────────────┘    └──────────────┘                       │  │
│  └─────────┼──────────────────────────────────────────────────────────────────────┘  │
│            │                                                                          │
│            ├──────────────────────────────────────────────────────────────────────┐  │
│            │                                                                      │  │
│            ▼                                                                      ▼  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │  │
│  │                      SECURITY & ACCESS                                     │  │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │  │  │
│  │  │   KMS    │─▶│ Secrets  │  │   IAM    │  │  Custom  │  │  Audit   │   │  │  │
│  │  │ (Keys)   │  │ Manager  │  │ Service  │  │   Roles  │  │ Logging  │   │  │  │
│  │  └──────────┘  └──────────┘  │ Accounts │  └──────────┘  └──────────┘   │  │  │
│  │                               └──────────┘                                │  │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │  │
│                                                                                │  │
│            │                                                                   │  │
│            ├───────────────────────────────────────────────────────────────────┘  │
│            │                                                                     │
│            ▼                                                                     │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │                    MONITORING & OBSERVABILITY                             │  │  │
│  │  ┌──────────────┐                    ┌──────────────┐                     │  │  │
│  │  │ Monitoring   │                    │   Error     │                     │  │  │
│  │  │ (Alerts/     │                    │  Reporting  │                     │  │  │
│  │  │ Dashboards)  │                    │             │                     │  │  │
│  │  └──────────────┘                    └──────────────┘                     │  │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │  │
│                                                                                │  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │  │
│  │                        DATA & MESSAGING                                    │  │  │
│  │  ┌──────────────┐                    ┌──────────────┐                     │  │  │
│  │  │   Pub/Sub    │                    │  BigQuery    │                     │  │  │
│  │  │  (Events)    │                    │ (Analytics)  │                     │  │  │
│  │  └──────────────┘                    └──────────────┘                     │  │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │  │
│                                                                                │  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │  │
│  │                        COST MANAGEMENT                                    │  │  │
│  │  ┌──────────────┐                                                         │  │  │
│  │  │   Budget     │                                                         │  │  │
│  │  │   Alerts     │                                                         │  │  │
│  │  └──────────────┘                                                         │  │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │  │
│                                                                                │  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │  │
│  │                            UTILITIES                                      │  │  │
│  │  ┌──────────────┐                                                         │  │  │
│  │  │ API Enable   │  (Enables required GCP APIs)                          │  │  │
│  │  └──────────────┘                                                         │  │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW                                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Developer ──▶ GitLab ──▶ Cloud Build ──▶ Artifact Registry ──▶ Cloud Run      │
│     │             │            │                  │                    │         │
│     │             │            │                  │                    │         │
│     └─────────────┴────────────┴──────────────────┴────────────────────┘         │
│                                                                                 │
│  Cloud Run ──▶ Internal LB ──▶ SSL Policy ──▶ DNS ──▶ Users                   │
│     │               │              │            │                                │
│     ├───────────────┴──────────────┴────────────┘                                │
│     │                                                                           │
│     ├──▶ Secrets Manager ◀── KMS                                               │
│     ├──▶ Pub/Sub ──▶ BigQuery                                                    │
│     ├──▶ Monitoring ──▶ Error Reporting                                        │
│     └──▶ Audit Logging                                                          │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Requirements

- Terraform >= 1.5.0
- Google Cloud Provider >= 4.65.0
- GCP Project with APIs enabled

## Installation

```bash
# Clone repository
git clone https://github.com/YOUR_ORG/terraform-gcp-stack.git
cd terraform-gcp-stack

# Initialize Terraform
terraform init
```

## Examples

See [examples/](examples/) directory for complete examples:
- [Basic Cloud Run Service](examples/basic/)
- [With Load Balancer](examples/with-lb/)

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Google Cloud Platform
- Terraform Community
- Contributors
