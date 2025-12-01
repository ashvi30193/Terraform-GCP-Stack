# Contributing to Terraform GCP Stack

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## 🚀 Getting Started

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/terraform-gcp-stack.git
   cd terraform-gcp-stack
   ```
3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Code Style

- Follow [Terraform Style Guide](https://www.terraform.io/docs/language/syntax/style.html)
- Use `terraform fmt` to format code
- Use `terraform validate` to check syntax
- Add comments for complex logic
- Document all variables and outputs

## 🧪 Testing

1. **Validate Terraform**
   ```bash
   terraform init
   terraform validate
   terraform fmt -check
   ```

2. **Test with examples**
   ```bash
   cd examples/basic
   terraform init
   terraform plan
   ```

## 📦 Module Structure

Each module should follow this structure:

```
modules/
└── module_name/
    ├── main.tf          # Resources
    ├── variables.tf     # Input variables
    ├── outputs.tf      # Output values
    └── README.md        # Module documentation
```

## 📚 Documentation

- Update README.md for new features
- Add examples in `examples/` directory
- Document all variables and outputs
- Include usage examples

## 🔍 Pull Request Process

1. **Update documentation** for any changes
2. **Add tests** if applicable
3. **Ensure all checks pass**
4. **Create pull request** with clear description
5. **Link related issues** if any

## ✅ Checklist

Before submitting a PR:

- [ ] Code follows style guidelines
- [ ] `terraform fmt` has been run
- [ ] `terraform validate` passes
- [ ] Documentation updated
- [ ] Examples tested
- [ ] No hardcoded values
- [ ] Variables properly typed
- [ ] Outputs documented

## 🐛 Reporting Issues

Use GitHub Issues to report bugs or request features. Include:
- Terraform version
- GCP provider version
- Error messages
- Steps to reproduce
- Expected vs actual behavior

## 💡 Feature Requests

We welcome feature requests! Please:
- Check if feature already exists
- Describe use case
- Provide examples if possible

## 📧 Questions?

Open a GitHub Discussion or contact maintainers.

Thank you for contributing! 🙏

