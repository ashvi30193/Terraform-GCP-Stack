# ==============================================================================
# Pub/Sub Module - Topic and Subscription Management
# ==============================================================================

# ------------------------------------------------------------------------------
# Pub/Sub Topics
# ------------------------------------------------------------------------------
resource "google_pubsub_topic" "topics" {
  for_each = { for t in var.topics : t.name => t }

  project = var.project_id
  name    = "${each.value.name}-${var.environment}"

  message_retention_duration = try(each.value.message_retention_duration, "604800s") # 7 days default

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )
}

# Dead letter topic for failed messages
resource "google_pubsub_topic" "dead_letter" {
  for_each = { for t in var.topics : t.name => t if try(t.enable_dead_letter, false) }

  project = var.project_id
  name    = "${each.value.name}-${var.environment}-dlq"

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      type        = "dead-letter"
    },
    var.labels
  )
}

# ------------------------------------------------------------------------------
# Pub/Sub Subscriptions
# ------------------------------------------------------------------------------
resource "google_pubsub_subscription" "subscriptions" {
  for_each = { for s in var.subscriptions : s.name => s }

  project = var.project_id
  name    = "${each.value.name}-${var.environment}"
  topic   = google_pubsub_topic.topics[each.value.topic].id

  # Acknowledgement deadline (default 10 seconds)
  ack_deadline_seconds = try(each.value.ack_deadline_seconds, 10)

  # Message retention (default 7 days)
  message_retention_duration = try(each.value.message_retention_duration, "604800s")

  # Retain acknowledged messages (default false)
  retain_acked_messages = try(each.value.retain_acked_messages, false)

  # Expiration policy (subscriptions expire after 31 days of inactivity by default)
  expiration_policy {
    ttl = try(each.value.expiration_ttl, "2678400s") # 31 days
  }

  # Push configuration (if push_endpoint is provided)
  dynamic "push_config" {
    for_each = try(each.value.push_endpoint, "") != "" ? [1] : []
    content {
      push_endpoint = each.value.push_endpoint

      dynamic "oidc_token" {
        for_each = try(each.value.push_service_account, "") != "" ? [1] : []
        content {
          service_account_email = each.value.push_service_account
        }
      }
    }
  }

  # Retry policy
  retry_policy {
    minimum_backoff = try(each.value.retry_minimum_backoff, "10s")
    maximum_backoff = try(each.value.retry_maximum_backoff, "600s")
  }

  # Enable message ordering if specified
  enable_message_ordering = try(each.value.enable_message_ordering, false)

  # Filter (if provided)
  filter = try(each.value.filter, null)

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.labels
  )
}

# BigQuery subscription (writes messages directly to BigQuery)
resource "google_pubsub_subscription" "bigquery_subscriptions" {
  for_each = { for s in var.subscriptions : s.name => s if try(s.bigquery_config, null) != null }

  project = var.project_id
  name    = "${each.value.name}-bq-${var.environment}"
  topic   = google_pubsub_topic.topics[each.value.topic].id

  bigquery_config {
    table               = each.value.bigquery_config.table
    write_metadata      = try(each.value.bigquery_config.write_metadata, false)
    drop_unknown_fields = try(each.value.bigquery_config.drop_unknown_fields, false)
  }

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      type        = "bigquery"
    },
    var.labels
  )
}

# ------------------------------------------------------------------------------
# IAM Bindings for Pub/Sub
# ------------------------------------------------------------------------------

# Grant Publisher role to specified members on topics
resource "google_pubsub_topic_iam_member" "publishers" {
  for_each = {
    for pair in setproduct(keys(google_pubsub_topic.topics), distinct(var.publisher_members)) :
    "${pair[0]}-${pair[1]}" => {
      topic  = pair[0]
      member = pair[1]
    }
  }

  project = var.project_id
  topic   = google_pubsub_topic.topics[each.value.topic].name
  role    = "roles/pubsub.publisher"
  member  = each.value.member
}

# Grant Subscriber role to specified members on subscriptions
resource "google_pubsub_subscription_iam_member" "subscribers" {
  for_each = {
    for pair in setproduct(keys(google_pubsub_subscription.subscriptions), distinct(var.subscriber_members)) :
    "${pair[0]}-${pair[1]}" => {
      subscription = pair[0]
      member       = pair[1]
    }
  }

  project      = var.project_id
  subscription = google_pubsub_subscription.subscriptions[each.value.subscription].name
  role         = "roles/pubsub.subscriber"
  member       = each.value.member
}

