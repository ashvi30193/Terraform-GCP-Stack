# ==============================================================================
# BigQuery Module - Outputs
# ==============================================================================

output "dataset_ids" {
  description = "Map of dataset names to their IDs"
  value       = { for k, v in google_bigquery_dataset.datasets : k => v.dataset_id }
}

output "dataset_self_links" {
  description = "Map of dataset names to their self links"
  value       = { for k, v in google_bigquery_dataset.datasets : k => v.self_link }
}

output "table_ids" {
  description = "Map of table keys to their IDs"
  value       = { for k, v in google_bigquery_table.tables : k => v.table_id }
}

output "fully_qualified_table_ids" {
  description = "Map of table keys to their fully qualified IDs (project.dataset.table)"
  value = {
    for k, v in google_bigquery_table.tables :
    k => "${var.project_id}.${v.dataset_id}.${v.table_id}"
  }
}
