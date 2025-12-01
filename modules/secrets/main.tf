# ------------------------------------------------------------------------------
# Secret Manager secrets with optional KMS encryption
# ------------------------------------------------------------------------------
resource "google_secret_manager_secret" "secrets" {
  for_each  = var.secret_names
  secret_id = "${var.name_prefix}-${var.environment}-${each.value}"
  project   = var.project_id

  dynamic "replication" {
    for_each = var.kms_crypto_key_id != null ? [1] : []
    content {
      user_managed {
        replicas {
          location = var.region
          customer_managed_encryption {
            kms_key_name = var.kms_crypto_key_id
          }
        }
      }
    }
  }

  dynamic "replication" {
    for_each = var.kms_crypto_key_id == null ? [1] : []
    content {
      auto {}
    }
  }

  labels = merge(
    {
      service     = var.name_prefix
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )
}

resource "google_secret_manager_secret_version" "versions" {
  for_each    = var.secret_names
  secret      = google_secret_manager_secret.secrets[each.value].id
  secret_data = var.secret_values[each.value]

  lifecycle {
    # Prevent accidental deletion of secret versions
    prevent_destroy = false
  }
}

# ------------------------------------------------------------------------------
# IAM bindings for Secret Manager
# ------------------------------------------------------------------------------
resource "google_secret_manager_secret_iam_member" "accessor" {
  for_each = {
    for pair in setproduct(var.secret_names, var.accessor_members) :
    "${pair[0]}-${pair[1]}" => {
      secret = pair[0]
      member = pair[1]
    }
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.member
}

