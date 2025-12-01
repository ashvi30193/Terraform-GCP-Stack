# ==============================================================================
# Pub/Sub Module - Outputs
# ==============================================================================

output "topic_ids" {
  description = "Map of topic names to their IDs"
  value       = { for k, v in google_pubsub_topic.topics : k => v.id }
}

output "topic_names" {
  description = "Map of topic keys to their full names"
  value       = { for k, v in google_pubsub_topic.topics : k => v.name }
}

output "subscription_ids" {
  description = "Map of subscription names to their IDs"
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.id }
}

output "subscription_names" {
  description = "Map of subscription keys to their full names"
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.name }
}

output "dead_letter_topic_ids" {
  description = "Map of dead letter topic names to their IDs"
  value       = { for k, v in google_pubsub_topic.dead_letter : k => v.id }
}


