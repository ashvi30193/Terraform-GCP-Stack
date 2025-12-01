# ==============================================================================
# Service Account Module
# Creates service accounts with necessary IAM bindings
# ==============================================================================

# Create the service account
resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  project      = var.project_id
}

# Grant project-level IAM roles to the service account
resource "google_project_iam_member" "project_roles" {
  for_each = toset(var.project_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Allow other principals to impersonate this service account
resource "google_service_account_iam_member" "impersonators" {
  for_each = toset(var.impersonators)

  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = each.value
}

# Allow other principals to generate tokens for this service account
resource "google_service_account_iam_member" "token_creators" {
  for_each = toset(var.token_creators)

  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = each.value
}

# Workload Identity binding (for GKE or Cloud Run)
resource "google_service_account_iam_member" "workload_identity" {
  for_each = toset(var.workload_identity_users)

  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value
}


