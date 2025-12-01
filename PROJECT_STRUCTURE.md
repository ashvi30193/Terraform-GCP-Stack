# Project Structure

```
terraform-gcp-stack/
├── README.md                    # Main project documentation
├── LICENSE                      # MIT License
├── CONTRIBUTING.md             # Contribution guidelines
├── PROJECT_STRUCTURE.md        # This file
│
├── main.tf                     # Root module example
├── variables.tf                # Root variables
├── outputs.tf                  # Root outputs
├── .gitignore                  # Git ignore rules
│
├── .github/
│   └── workflows/
│       ├── terraform.yml       # CI/CD pipeline
│       └── test.yml           # Test workflow
├── scripts/
│   └── test.sh                # Test script
├── tests/
│   ├── README.md              # Testing guide
│   └── unit/
│       └── test_modules.sh    # Unit tests
├── Makefile                    # Make targets
├── TESTING.md                  # Testing documentation
│
├── modules/                    # Reusable Terraform modules (16 modules)
│   ├── api/                   # Enable Google Cloud APIs
│   ├── audit_logging/         # Security audit trails
│   ├── bigquery/              # BigQuery datasets and tables
│   ├── budget_alerts/         # Cost monitoring and alerts
│   ├── cloud_build/           # CI/CD triggers
│   ├── cloud_run/             # Cloud Run services
│   ├── custom_iam_roles/      # Custom IAM roles
│   ├── error_reporting/       # Error detection
│   ├── iam_service_account/   # Service accounts
│   ├── internal_lb/           # Internal load balancers
│   ├── kms/                   # Key Management Service
│   ├── monitoring/            # Monitoring and alerts
│   ├── pubsub/                # Pub/Sub topics
│   ├── scheduler/             # Cloud Scheduler
│   ├── secrets/               # Secret Manager
│   └── ssl_policy/            # SSL policies
│
├── examples/                   # Usage examples
│   ├── basic/
│   │   ├── main.tf
│   │   └── README.md
│   │
│   └── with-lb/
│       ├── main.tf
│       └── README.md
│
└── docs/                       # Additional documentation
    ├── GETTING_STARTED.md
    └── MODULES.md
```

## Module Organization

Each module follows a consistent structure:
- `main.tf` - Resource definitions
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `README.md` - Module documentation

## Best Practices

1. **Modularity**: Each module is self-contained and reusable
2. **Documentation**: Every module has a README with examples
3. **Examples**: Working examples demonstrate usage
4. **CI/CD**: Automated validation via GitHub Actions
5. **Versioning**: Semantic versioning for releases

