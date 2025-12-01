#!/bin/bash
# Terraform Module Testing Script
# Validates all modules and examples

set -e

echo "🔍 Running Terraform Module Tests"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to check command
check_cmd() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}⚠️  $1 not found, skipping${NC}"
        return 1
    fi
    return 0
}

# 1. Format Check
echo ""
echo "📝 Checking Terraform formatting..."
if terraform fmt -check -recursive; then
    echo -e "${GREEN}✅ Formatting OK${NC}"
else
    echo -e "${RED}❌ Formatting issues found${NC}"
    echo "Run: terraform fmt -recursive"
    ERRORS=$((ERRORS + 1))
fi

# 2. Validate Root Module
echo ""
echo "🔍 Validating root module..."
if [ -f "main.tf" ]; then
    terraform init -backend=false > /dev/null 2>&1
    if terraform validate > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Root module valid${NC}"
    else
        echo -e "${RED}❌ Root module validation failed${NC}"
        ERRORS=$((ERRORS + 1))
    fi
fi

# 3. Validate Each Module
echo ""
echo "🔍 Validating modules..."
for module in modules/*/; do
    if [ -d "$module" ]; then
        module_name=$(basename "$module")
        echo "  Checking $module_name..."
        cd "$module"
        
        if terraform init -backend=false > /dev/null 2>&1; then
            if terraform validate > /dev/null 2>&1; then
                echo -e "    ${GREEN}✅ $module_name valid${NC}"
            else
                echo -e "    ${RED}❌ $module_name validation failed${NC}"
                terraform validate
                ERRORS=$((ERRORS + 1))
            fi
        else
            echo -e "    ${YELLOW}⚠️  $module_name init failed (may need provider config)${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        cd - > /dev/null
    fi
done

# 4. Validate Examples
echo ""
echo "🔍 Validating examples..."
for example in examples/*/; do
    if [ -d "$example" ] && [ -f "$example/main.tf" ]; then
        example_name=$(basename "$example")
        echo "  Checking $example_name..."
        cd "$example"
        
        if terraform init -backend=false > /dev/null 2>&1; then
            if terraform validate > /dev/null 2>&1; then
                echo -e "    ${GREEN}✅ $example_name valid${NC}"
            else
                echo -e "    ${RED}❌ $example_name validation failed${NC}"
                ERRORS=$((ERRORS + 1))
            fi
        else
            echo -e "    ${YELLOW}⚠️  $example_name init failed${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        cd - > /dev/null
    fi
done

# 5. Check for hardcoded values
echo ""
echo "🔍 Checking for hardcoded project IDs..."
HARDCODED=$(grep -r "projects/[a-z0-9-]*" modules/ examples/ --include="*.tf" 2>/dev/null | grep -v "variable\|output\|description\|var\.project_id\|\${var\.project_id}" | wc -l || echo "0")
if [ "$HARDCODED" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found potential hardcoded project IDs${NC}"
    grep -r "projects/[a-z0-9-]*" modules/ examples/ --include="*.tf" 2>/dev/null | grep -v "variable\|output\|description\|var\.project_id\|\${var\.project_id}" || true
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ No hardcoded project IDs found${NC}"
fi

# 6. Check for organizational data
echo ""
echo "🔍 Checking for organizational data..."
ORG_DATA=$(grep -ri "telekom\|t-systems\|incidentsense\|de1000" modules/ examples/ --include="*.tf" --include="*.md" 2>/dev/null | wc -l || echo "0")
if [ "$ORG_DATA" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found potential organizational data${NC}"
    grep -ri "telekom\|t-systems\|incidentsense\|de1000" modules/ examples/ --include="*.tf" --include="*.md" 2>/dev/null || true
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ No organizational data found${NC}"
fi

# Summary
echo ""
echo "=================================="
echo "📊 Test Summary"
echo "=================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Tests passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}❌ Tests failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    exit 1
fi

