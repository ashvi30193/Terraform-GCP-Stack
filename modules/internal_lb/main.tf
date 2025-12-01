# ==============================================================================
# Internal Load Balancer Module with HTTPS Support
# ==============================================================================

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.65.0"
    }
  }
}

# ------------------------------------------------------------------------------
# Network Endpoint Group (Serverless NEG for Cloud Run)
# ------------------------------------------------------------------------------
resource "google_compute_region_network_endpoint_group" "neg" {
  name                  = var.neg_name
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.service_name
  }
}

# ------------------------------------------------------------------------------
# Backend Service
# ------------------------------------------------------------------------------
resource "google_compute_region_backend_service" "backend" {
  name                  = var.backend_service_name
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTPS"
  region                = var.region

  backend {
    group = google_compute_region_network_endpoint_group.neg.id
  }
}

# ------------------------------------------------------------------------------
# URL Map
# ------------------------------------------------------------------------------
resource "google_compute_region_url_map" "url_map" {
  name            = var.url_map_name
  region          = var.region
  default_service = google_compute_region_backend_service.backend.id
}

# ------------------------------------------------------------------------------
# HTTPS Target Proxy (with Certificate Manager certificate and SSL policy)
# ------------------------------------------------------------------------------
resource "google_compute_region_target_https_proxy" "https_proxy" {
  count = var.ssl_certificate != null ? 1 : 0

  name    = "${var.url_map_name}-https-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.url_map.id

  # Use certificate_manager_certificates for Certificate Manager certs
  # Format: //certificatemanager.googleapis.com/projects/PROJECT/locations/REGION/certificates/CERT_NAME
  certificate_manager_certificates = [var.ssl_certificate]

  # SSL Policy for TLS configuration
  ssl_policy = var.ssl_policy
}

# ------------------------------------------------------------------------------
# HTTP Target Proxy (fallback if no certificate)
# ------------------------------------------------------------------------------
resource "google_compute_region_target_http_proxy" "http_proxy" {
  count = var.ssl_certificate == null ? 1 : 0

  name    = "${var.url_map_name}-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.url_map.id
}

# ------------------------------------------------------------------------------
# Forwarding Rule (HTTPS on port 443 or HTTP on port 80)
# ------------------------------------------------------------------------------
resource "google_compute_forwarding_rule" "frontend_fr" {
  name                  = "${var.url_map_name}-${var.ssl_certificate != null ? "https" : "http"}-fr"
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  network               = "${var.gcp_url}/${var.network}"
  subnetwork            = "${var.gcp_url}/${var.subnet}"
  target                = var.ssl_certificate != null ? google_compute_region_target_https_proxy.https_proxy[0].id : google_compute_region_target_http_proxy.http_proxy[0].id
  port_range            = var.ssl_certificate != null ? "443" : "80"
  ip_protocol           = "TCP"
  allow_global_access   = true
}
