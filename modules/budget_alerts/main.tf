# ==============================================================================
# Budget Alerts Module
# Creates budget alerts to monitor and control cloud spending
# ==============================================================================

# ------------------------------------------------------------------------------
# Project Budget
# Alerts when spending approaches or exceeds defined thresholds
# ------------------------------------------------------------------------------
resource "google_billing_budget" "project_budget" {
  count = var.billing_account_id != "" ? 1 : 0

  billing_account = var.billing_account_id
  display_name    = "${var.project_name} - ${var.environment} Budget"

  budget_filter {
    projects               = ["projects/${var.project_id}"]
    credit_types_treatment = "INCLUDE_ALL_CREDITS"

    # Optional: Filter by specific services
    dynamic "custom_period" {
      for_each = var.custom_period_start != "" ? [1] : []
      content {
        start_date {
          year  = tonumber(split("-", var.custom_period_start)[0])
          month = tonumber(split("-", var.custom_period_start)[1])
          day   = tonumber(split("-", var.custom_period_start)[2])
        }
        end_date {
          year  = tonumber(split("-", var.custom_period_end)[0])
          month = tonumber(split("-", var.custom_period_end)[1])
          day   = tonumber(split("-", var.custom_period_end)[2])
        }
      }
    }
  }

  amount {
    specified_amount {
      currency_code = var.currency
      units         = tostring(var.budget_amount)
    }
  }

  # Alert thresholds (percentage of budget)
  dynamic "threshold_rules" {
    for_each = var.alert_thresholds
    content {
      threshold_percent = threshold_rules.value / 100
      spend_basis       = "CURRENT_SPEND"
    }
  }

  # Forecasted spend alerts
  dynamic "threshold_rules" {
    for_each = var.forecast_thresholds
    content {
      threshold_percent = threshold_rules.value / 100
      spend_basis       = "FORECASTED_SPEND"
    }
  }

  # Notifications
  all_updates_rule {
    # Email notifications to billing admins
    monitoring_notification_channels = var.notification_channel_ids

    # Pub/Sub topic for programmatic alerts (optional)
    pubsub_topic = var.pubsub_topic_id != "" ? var.pubsub_topic_id : null

    # Disable default email to billing admins if custom channels are set
    disable_default_iam_recipients = length(var.notification_channel_ids) > 0
  }
}

# ------------------------------------------------------------------------------
# Service-specific Budgets (Optional)
# Monitor spending per service (Cloud Run, BigQuery, etc.)
# ------------------------------------------------------------------------------
resource "google_billing_budget" "service_budgets" {
  for_each = var.billing_account_id != "" ? var.service_budgets : {}

  billing_account = var.billing_account_id
  display_name    = "${var.project_name} - ${each.key} Budget"

  budget_filter {
    projects               = ["projects/${var.project_id}"]
    credit_types_treatment = "INCLUDE_ALL_CREDITS"
    services               = each.value.services
  }

  amount {
    specified_amount {
      currency_code = var.currency
      units         = tostring(each.value.amount)
    }
  }

  # Alert at 50%, 80%, 100%
  threshold_rules {
    threshold_percent = 0.5
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 0.8
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "CURRENT_SPEND"
  }

  all_updates_rule {
    monitoring_notification_channels = var.notification_channel_ids
    disable_default_iam_recipients   = length(var.notification_channel_ids) > 0
  }
}

# ------------------------------------------------------------------------------
# Notification Channel for Budget Alerts (Email)
# Creates email notification channels if emails are provided
# ------------------------------------------------------------------------------
resource "google_monitoring_notification_channel" "budget_email" {
  for_each = toset(var.notification_emails)

  project      = var.project_id
  display_name = "Budget Alert - ${each.value}"
  type         = "email"

  labels = {
    email_address = each.value
  }

  user_labels = {
    environment = var.environment
    purpose     = "budget-alerts"
  }
}

