# Testing Guide

Comprehensive testing guide for Terraform GCP Stack.

## Quick Start

```bash
# Run all tests
make test

# Or use the test script
./scripts/test.sh

# Or use Makefile targets
make validate
make fmt-check
make lint
```

## Test Types

### 1. Formatting Tests

Ensures all Terraform files follow standard formatting:

```bash
terraform fmt -check -recursive
```

**Fix formatting:**
```bash
terraform fmt -recursive
```

### 2. Validation Tests

Validates Terraform syntax and configuration:

```bash
# Root module
terraform init -backend=false
terraform validate

# Individual modules
cd modules/cloud_run
terraform init -backend=false
terraform validate
```

### 3. Linting Tests

Checks for:
- Hardcoded project IDs
- Organizational data
- Best practices

```bash
make lint
# or
make check-org-data
make check-hardcoded
```

### 4. Example Tests

Validates all examples work correctly:

```bash
cd examples/basic
terraform init -backend=false
terraform validate
```

## Test Structure

```
tests/
├── README.md              # Testing documentation
└── unit/
    └── test_modules.sh    # Unit test script
```

## Makefile Targets

| Target | Description |
|--------|-------------|
| `make fmt` | Format all Terraform files |
| `make fmt-check` | Check formatting without fixing |
| `make validate` | Validate all modules and examples |
| `make test` | Run all tests (fmt + validate) |
| `make lint` | Run linting checks |
| `make check-org-data` | Check for organizational data |
| `make check-hardcoded` | Check for hardcoded values |
| `make clean` | Clean Terraform state files |
| `make all` | Run all checks and tests |

## CI/CD Testing

Tests run automatically on:
- **Pull Requests**: Full validation suite
- **Pushes to main**: Format and validate

See `.github/workflows/` for CI configuration.

## Pre-Commit Checklist

Before submitting a PR:

- [ ] `make fmt` - Format all files
- [ ] `make validate` - Validate all modules
- [ ] `make lint` - Check for issues
- [ ] Examples validate successfully
- [ ] Documentation updated
- [ ] No hardcoded project IDs
- [ ] No organizational data

## Manual Testing

### Test Individual Module

```bash
./tests/unit/test_modules.sh cloud_run
```

### Test Example

```bash
cd examples/basic
terraform init -backend=false
terraform validate
terraform plan -var="project_id=test-project"
```

## Common Issues

### Validation Fails

**Issue:** `Error: Missing required provider`
**Fix:** Run `terraform init -backend=false` in module directory

### Formatting Issues

**Issue:** `terraform fmt -check` fails
**Fix:** Run `terraform fmt -recursive`

### Hardcoded Values

**Issue:** Test detects hardcoded project IDs
**Fix:** Use variables instead of hardcoded values

## Test Coverage

✅ **Formatting**: All `.tf` files
✅ **Validation**: All modules and examples
✅ **Linting**: Hardcoded values, org data
✅ **CI/CD**: Automated on PR and push

## Adding New Tests

1. Add test to `tests/unit/` or `tests/integration/`
2. Update `scripts/test.sh` if needed
3. Add to CI workflow in `.github/workflows/`
4. Document in this file

## Resources

- [Terraform Testing](https://www.terraform.io/docs/language/modules/testing.html)
- [Terraform Best Practices](https://www.terraform.io/docs/language/modules/develop/index.html)

