#!/bin/bash
# Unit tests for individual modules

set -e

MODULE=$1

if [ -z "$MODULE" ]; then
    echo "Usage: $0 <module_name>"
    echo "Example: $0 cloud_run"
    exit 1
fi

MODULE_PATH="modules/$MODULE"

if [ ! -d "$MODULE_PATH" ]; then
    echo "Module $MODULE not found"
    exit 1
fi

echo "Testing module: $MODULE"
cd "$MODULE_PATH"

# Initialize
terraform init -backend=false

# Validate
terraform validate

# Format check
terraform fmt -check

echo "✅ Module $MODULE passed all tests"

