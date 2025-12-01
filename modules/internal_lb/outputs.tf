output "ip_address" {
  description = "Forwarding rule IP for the LB"
  value       = google_compute_forwarding_rule.frontend_fr.ip_address
}