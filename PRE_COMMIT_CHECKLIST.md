# Pre-Commit Checklist

Use this checklist before committing code to ensure quality and consistency.

## Code Quality

- [ ] `terraform fmt -recursive` has been run
- [ ] `terraform validate` passes for all modules
- [ ] No hardcoded project IDs or values
- [ ] No organizational data (company names, emails, etc.)
- [ ] Variables properly typed and documented
- [ ] Outputs documented

## Documentation

- [ ] README.md updated if needed
- [ ] Module READMEs updated
- [ ] Examples tested and working
- [ ] Code comments added for complex logic

## Testing

- [ ] All modules validate successfully
- [ ] Examples validate successfully
- [ ] `make test` passes
- [ ] `make lint` passes

## Security

- [ ] No credentials or secrets in code
- [ ] No access tokens or API keys
- [ ] Sensitive data uses variables or secrets

## Git

- [ ] Meaningful commit message
- [ ] Related changes grouped together
- [ ] No large binary files
- [ ] `.gitignore` properly configured

## Quick Commands

```bash
# Run all checks
make test
make lint

# Format code
make fmt

# Validate
make validate
```

