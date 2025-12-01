# ------------------------------------------------------------------------------
# KMS Key Ring and Crypto Key for Encryption
# ------------------------------------------------------------------------------
resource "google_kms_key_ring" "keyring" {
  name     = "${var.name}-${var.environment}${var.suffix}-keyring"
  location = var.region
  project  = var.project_id
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = "${var.name}-${var.environment}${var.suffix}-key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period
  purpose         = var.purpose

  dynamic "version_template" {
    for_each = var.algorithm != null ? [1] : []
    content {
      algorithm        = var.algorithm
      protection_level = var.protection_level
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )
}

# ------------------------------------------------------------------------------
# IAM bindings for KMS
# ------------------------------------------------------------------------------

# Grant encrypter/decrypter role to specified members
resource "google_kms_crypto_key_iam_member" "encrypter_decrypter" {
  for_each      = toset(var.encrypter_decrypter_members)
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = each.value
}

# Grant decrypter role to specified members
resource "google_kms_crypto_key_iam_member" "decrypter" {
  for_each      = toset(var.decrypter_members)
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  member        = each.value
}

# Grant encrypter role to specified members
resource "google_kms_crypto_key_iam_member" "encrypter" {
  for_each      = toset(var.encrypter_members)
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  member        = each.value
}

