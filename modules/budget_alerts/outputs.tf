# ==============================================================================
# Budget Alerts Module - Outputs
# ==============================================================================

output "project_budget_name" {
  description = "Name of the project budget"
  value       = length(google_billing_budget.project_budget) > 0 ? google_billing_budget.project_budget[0].display_name : null
}

output "project_budget_id" {
  description = "ID of the project budget"
  value       = length(google_billing_budget.project_budget) > 0 ? google_billing_budget.project_budget[0].id : null
}

output "service_budget_ids" {
  description = "Map of service budget IDs"
  value       = { for k, v in google_billing_budget.service_budgets : k => v.id }
}

output "notification_channel_ids" {
  description = "IDs of created email notification channels"
  value       = [for channel in google_monitoring_notification_channel.budget_email : channel.id]
}

