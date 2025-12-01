# Custom IAM Roles Module

Creates custom IAM roles for role-based access control (RBAC) with fine-grained permissions.

## Usage

```hcl
module "iam_roles" {
  source = "./modules/custom_iam_roles"

  project_id   = "my-gcp-project"
  project_name = "My Project"
  role_prefix  = "myproject"

  developers = [
    "user:developer1@example.com",
    "user:developer2@example.com"
  ]

  devops_engineers = [
    "user:devops@example.com"
  ]

  platform_admins = [
    "user:admin@example.com"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| project_name | Project display name | `string` | `""` | no |
| role_prefix | Prefix for role IDs | `string` | `"custom"` | no |
| developers | List of developer members | `list(string)` | `[]` | no |
| devops_engineers | List of DevOps members | `list(string)` | `[]` | no |
| platform_admins | List of platform admin members | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| developer_role_id | ID of the Developer role |
| devops_engineer_role_id | ID of the DevOps Engineer role |
| platform_admin_role_id | ID of the Platform Admin role |

## Roles Created

- **Developer**: Read-only access to Cloud Run, logs, metrics
- **DevOps Engineer**: Deploy and manage Cloud Run, Cloud Build, Secrets
- **Platform Admin**: Full infrastructure management permissions

