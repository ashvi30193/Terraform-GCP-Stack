# ==============================================================================
# BigQuery Module - Dataset and Table Management
# ==============================================================================

# ------------------------------------------------------------------------------
# BigQuery Datasets
# ------------------------------------------------------------------------------
resource "google_bigquery_dataset" "datasets" {
  for_each = { for d in var.datasets : d.id => d }

  project                    = var.project_id
  dataset_id                 = each.value.id
  location                   = try(each.value.location, "EU")
  description                = try(each.value.description, "Managed by Terraform")
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )
}

# ------------------------------------------------------------------------------
# BigQuery Tables (optional - created in existing datasets)
# ------------------------------------------------------------------------------
resource "google_bigquery_table" "tables" {
  for_each = { for t in var.tables : "${t.dataset}.${t.name}" => t }

  project             = var.project_id
  dataset_id          = each.value.dataset
  table_id            = each.value.name
  deletion_protection = var.table_deletion_protection

  # Use schema file if provided
  schema = try(file("${path.root}/${each.value.schema}"), null)

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )

  depends_on = [google_bigquery_dataset.datasets]
}

# ------------------------------------------------------------------------------
# IAM Bindings for BigQuery
# ------------------------------------------------------------------------------

# Grant Data Editor role to specified members on datasets
resource "google_bigquery_dataset_iam_member" "data_editors" {
  for_each = {
    for pair in setproduct(keys(google_bigquery_dataset.datasets), distinct(var.data_editor_members)) :
    "${pair[0]}-${pair[1]}" => {
      dataset = pair[0]
      member  = pair[1]
    }
  }

  project    = var.project_id
  dataset_id = google_bigquery_dataset.datasets[each.value.dataset].dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = each.value.member
}

# Grant Data Viewer role to specified members on datasets
resource "google_bigquery_dataset_iam_member" "data_viewers" {
  for_each = {
    for pair in setproduct(keys(google_bigquery_dataset.datasets), distinct(var.data_viewer_members)) :
    "${pair[0]}-${pair[1]}" => {
      dataset = pair[0]
      member  = pair[1]
    }
  }

  project    = var.project_id
  dataset_id = google_bigquery_dataset.datasets[each.value.dataset].dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = each.value.member
}
