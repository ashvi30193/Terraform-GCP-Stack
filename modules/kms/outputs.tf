output "keyring_id" {
  description = "The ID of the KMS keyring"
  value       = google_kms_key_ring.keyring.id
}

output "keyring_name" {
  description = "The name of the KMS keyring"
  value       = google_kms_key_ring.keyring.name
}

output "crypto_key_id" {
  description = "The ID of the KMS crypto key"
  value       = google_kms_crypto_key.crypto_key.id
}

output "crypto_key_name" {
  description = "The name of the KMS crypto key"
  value       = google_kms_crypto_key.crypto_key.name
}

output "crypto_key_self_link" {
  description = "The self link of the KMS crypto key"
  value       = google_kms_crypto_key.crypto_key.id
}

