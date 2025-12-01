# Testing Guide

This directory contains tests for validating Terraform modules.

## Test Structure

```
tests/
├── README.md              # This file
├── unit/                  # Unit tests (terraform validate)
├── integration/           # Integration tests (terraform plan)
└── examples/              # Example-based tests
```

## Running Tests

### Prerequisites

```bash
# Install Terraform
terraform version

# Install tflint (optional but recommended)
brew install tflint  # macOS
# or
wget https://github.com/terraform-linters/tflint/releases/download/v0.50.0/tflint_linux_amd64.zip
```

### Quick Test

```bash
# Run all validations
./scripts/test.sh

# Or manually:
terraform fmt -check -recursive
terraform validate
```

### Individual Module Tests

```bash
# Test a specific module
cd modules/cloud_run
terraform init -backend=false
terraform validate
terraform fmt -check
```

## Test Types

### 1. Formatting Tests

```bash
terraform fmt -check -recursive
```

### 2. Validation Tests

```bash
terraform init -backend=false
terraform validate
```

### 3. Linting Tests

```bash
tflint --recursive
```

### 4. Example Tests

```bash
cd examples/basic
terraform init -backend=false
terraform validate
```

## CI/CD Integration

Tests run automatically on:
- Pull requests
- Pushes to main branch

See `.github/workflows/terraform.yml` for CI configuration.

## Test Checklist

Before submitting PR:

- [ ] `terraform fmt -check` passes
- [ ] `terraform validate` passes for all modules
- [ ] Examples validate successfully
- [ ] No hardcoded project IDs
- [ ] No organizational data
- [ ] Documentation updated

