# ==============================================================================
# Cloud Run Service Module
# ==============================================================================

resource "google_cloud_run_v2_service" "cloud_run" {
  name                = var.service_name
  location            = var.region
  project             = var.project_id
  deletion_protection = false
  ingress             = var.ingress

  # Disable IAM invoker check for services behind internal LB
  # This allows anyone with network access to invoke the service
  invoker_iam_disabled = var.allow_unauthenticated

  template {
    containers {
      image = var.image
      ports { container_port = 8080 }

      resources {
        limits = {
          memory = var.memory
          cpu    = var.cpu
        }
      }

      # Regular environment variables
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # Secret environment variables from Secret Manager
      dynamic "env" {
        for_each = var.secret_env_vars
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value.secret_name
              version = env.value.version
            }
          }
        }
      }

      # Startup probe - gives container time to start (TCP socket check)
      startup_probe {
        initial_delay_seconds = 0
        timeout_seconds       = 240
        period_seconds        = 240
        failure_threshold     = 1

        tcp_socket {
          port = 8080
        }
      }
    }

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    max_instance_request_concurrency = var.container_concurrency
    timeout                          = "${var.request_timeout}s"
    service_account                  = var.service_account
    execution_environment            = var.execution_env

    vpc_access {
      network_interfaces {
        network    = var.network
        subnetwork = var.subnet
      }
      egress = var.vpc_egress
    }
  }
}

# Grant invoker role to the service account (for internal service-to-service calls)
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 0 : 1 # Only needed when IAM is enabled
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.cloud_run.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.service_account}"
}
