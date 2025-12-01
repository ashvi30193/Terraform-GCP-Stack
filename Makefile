.PHONY: help fmt validate test clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format all Terraform files
	terraform fmt -recursive

fmt-check: ## Check Terraform formatting
	terraform fmt -check -recursive

validate: ## Validate all modules
	@echo "Validating root module..."
	terraform init -backend=false
	terraform validate
	@echo "Validating modules..."
	@for module in modules/*/; do \
		if [ -d "$$module" ]; then \
			echo "  Validating $$(basename $$module)..."; \
			cd "$$module" && terraform init -backend=false && terraform validate && cd - > /dev/null || exit 1; \
		fi \
	done
	@echo "Validating examples..."
	@for example in examples/*/; do \
		if [ -d "$$example" ] && [ -f "$$example/main.tf" ]; then \
			echo "  Validating $$(basename $$example)..."; \
			cd "$$example" && terraform init -backend=false && terraform validate && cd - > /dev/null || exit 1; \
		fi \
	done

test: fmt-check validate ## Run all tests
	@echo "✅ All tests passed!"

clean: ## Clean Terraform files
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	find . -type f -name "*.tfstate" -delete 2>/dev/null || true
	find . -type f -name "*.tfstate.*" -delete 2>/dev/null || true

check-org-data: ## Check for organizational data
	@echo "Checking for organizational data..."
	@if grep -ri "telekom\|t-systems\|incidentsense\|de1000" modules/ examples/ --include="*.tf" --include="*.md" 2>/dev/null; then \
		echo "❌ Found organizational data"; \
		exit 1; \
	else \
		echo "✅ No organizational data found"; \
	fi

check-hardcoded: ## Check for hardcoded project IDs
	@echo "Checking for hardcoded project IDs..."
	@HARDCODED=$$(grep -r "projects/[a-z0-9-]*" modules/ examples/ --include="*.tf" 2>/dev/null | grep -v "variable\|output\|description\|var.project_id\|\$${var.project_id}\|#\|PROJECT" || true); \
	if [ -n "$$HARDCODED" ]; then \
		echo "❌ Found hardcoded project IDs (excluding variable references and comments)"; \
		echo "$$HARDCODED"; \
		exit 1; \
	else \
		echo "✅ No hardcoded project IDs found"; \
	fi

lint: check-org-data check-hardcoded ## Run all linting checks

all: fmt validate lint test ## Run all checks and tests

