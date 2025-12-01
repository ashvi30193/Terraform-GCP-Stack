# BigQuery Module

Creates BigQuery datasets and tables with schemas.

## Usage

```hcl
module "bigquery" {
  source = "./modules/bigquery"

  project_id = "my-gcp-project"
  region     = "us-central1"

  datasets = {
    "my_dataset" = {
      name        = "my_dataset"
      description = "My dataset"
    }
  }

  tables = {
    "my_table" = {
      dataset_id = "my_dataset"
      table_id   = "my_table"
      schema     = file("schemas/my_table.json")
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | GCP Project ID | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| datasets | Map of datasets to create | `map(object)` | `{}` | no |
| tables | Map of tables to create | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| dataset_ids | Map of dataset IDs |
| table_ids | Map of table IDs |

