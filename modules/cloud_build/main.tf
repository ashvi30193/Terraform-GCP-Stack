# ------------------------------------------------------------------------------
# Cloud Build trigger using Cloud Build service account (GitLab tag trigger)
# ------------------------------------------------------------------------------
resource "google_cloudbuild_trigger" "gitlab_trigger" {
  project         = var.project_id
  name            = "${var.service_name}-${var.environment}-tag"
  description     = "Build and deploy ${var.service_name} (${var.environment}) from GitLab on tag creation"
  location        = var.region
  service_account = var.service_account_cloud_build

  repository_event_config {
    repository = var.gitlab_repo_id
    push {
      # Only trigger on tags matching the pattern (e.g., frontend-.*)
      tag = var.tag_pattern
    }
  }

  substitutions = merge(
    {
      _SERVICE_DIR            = var.service_dir
      _DOCKERFILE             = var.dockerfile_path
      _IMAGE_REPO             = var.image_repo
      _IMAGE_TAG              = var.image_tag
      _CLOUD_RUN_SERVICE_NAME = var.cloud_run_service_name
      _REGION_NAME            = var.region
      _PROJECT_ID             = var.project_id
      _ENVIRONMENT            = var.environment
      _SERVICE_ACCOUNT        = var.cloud_run_service_account
    },
    # Add env vars as substitutions for Cloud Run deploy
    { for k, v in var.cloud_run_env_vars : "_ENV_${k}" => v }
  )

  build {
    timeout = var.build_timeout

    options {
      logging = "CLOUD_LOGGING_ONLY"
    }

    # Step 0: Print variables (for debugging)
    step {
      id         = "print-vars"
      name       = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "echo SERVICE_DIR=$_SERVICE_DIR; echo IMAGE_REPO=$_IMAGE_REPO; echo IMAGE_TAG=$_IMAGE_TAG; echo ENVIRONMENT=$_ENVIRONMENT; ls -la $_SERVICE_DIR"
      ]
    }

    # Step 1: Build Docker image (uses git tag as image tag via $TAG_NAME)
    step {
      id         = "build-${var.environment}-${var.service_name}"
      name       = "gcr.io/cloud-builders/docker"
      entrypoint = "bash"
      args = [
        "-c",
        <<-EOT
          echo "=== Running Docker build for ${var.environment} ==="
          echo "Git Tag: $TAG_NAME"
          # Use git tag as image tag, fallback to _IMAGE_TAG if not available
          IMAGE_TAG=$${TAG_NAME:-$_IMAGE_TAG}
          docker build $_SERVICE_DIR \
            -f $_SERVICE_DIR/$_DOCKERFILE \
            -t $_IMAGE_REPO:$$IMAGE_TAG \
            -t $_IMAGE_REPO:$_ENVIRONMENT-latest \
            --build-arg BUILDPLATFORM=linux/amd64
          echo "Built image: $_IMAGE_REPO:$$IMAGE_TAG"
        EOT
      ]
      wait_for = ["print-vars"]
    }

    # Step 2: Push Docker image with tag (uses git tag name)
    step {
      id         = "push-${var.environment}-${var.service_name}-tag"
      name       = "gcr.io/cloud-builders/docker"
      entrypoint = "bash"
      args = [
        "-c",
        <<-EOT
          IMAGE_TAG=$${TAG_NAME:-$_IMAGE_TAG}
          docker push $_IMAGE_REPO:$$IMAGE_TAG
        EOT
      ]
      wait_for = ["build-${var.environment}-${var.service_name}"]
    }

    # Step 3: Push Docker image with latest tag
    step {
      id       = "push-${var.environment}-${var.service_name}-latest"
      name     = "gcr.io/cloud-builders/docker"
      args     = ["push", "$_IMAGE_REPO:$_ENVIRONMENT-latest"]
      wait_for = ["build-${var.environment}-${var.service_name}"]
    }

    # Step 4: Deploy to Cloud Run (with env vars and secrets)
    # Using ^@^ as delimiter to handle values with commas
    step {
      id         = "deploy-${var.environment}-${var.service_name}"
      name       = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args = [
        "-c",
        <<-EOT
          set -e
          IMAGE_TAG=$${TAG_NAME:-$_IMAGE_TAG}
          
          echo "Deploying $_CLOUD_RUN_SERVICE_NAME with image $_IMAGE_REPO:$$IMAGE_TAG"
          
          # Deploy to Cloud Run
          gcloud run deploy $_CLOUD_RUN_SERVICE_NAME \
            --image $_IMAGE_REPO:$$IMAGE_TAG \
            --region $_REGION_NAME \
            --platform managed \
            --project $_PROJECT_ID \
            --ingress internal \
            --allow-unauthenticated \
            --service-account $_SERVICE_ACCOUNT \
            %{if length(var.cloud_run_env_vars) > 0~}
            --update-env-vars="^;^${join(";", [for k, v in var.cloud_run_env_vars : "${k}=${v}"])}" \
            %{endif~}
            %{if length(var.secret_env_vars) > 0~}
            --set-secrets="${join(",", [for k, v in var.secret_env_vars : "${k}=${v}:latest"])}" \
            %{endif~}
            --quiet
          
          echo "Deployment complete"
        EOT
      ]
      wait_for = ["push-${var.environment}-${var.service_name}-tag", "push-${var.environment}-${var.service_name}-latest"]
    }
  }
}

# ------------------------------------------------------------------------------
# IAM bindings for Cloud Build Service Account
# Note: Using separate resources per service to avoid conflicts
# ------------------------------------------------------------------------------

locals {
  # Extract service account email from full path
  cb_sa_email = element(split("/", var.service_account_cloud_build), length(split("/", var.service_account_cloud_build)) - 1)
}

# Required for Cloud Build to write logs
resource "google_project_iam_member" "logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for Cloud Build to view logs
resource "google_project_iam_member" "logs_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for Cloud Build operations
resource "google_project_iam_member" "cloudbuild_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for Cloud Run deployment
resource "google_project_iam_member" "cloudrun_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for Cloud Run admin operations (update services)
resource "google_project_iam_member" "cloudrun_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for Cloud Run to act as service account
resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for storage operations (Cloud Build logs bucket)
resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for pushing images to Artifact Registry
resource "google_artifact_registry_repository_iam_member" "artifact_registry_writer" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${local.cb_sa_email}"
}

# Required for reading images from Artifact Registry
resource "google_artifact_registry_repository_iam_member" "artifact_registry_reader" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${local.cb_sa_email}"
}

# Required for accessing secrets (only if secrets are defined)
resource "google_project_iam_member" "secret_accessor" {
  count   = length(var.secret_env_vars) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${local.cb_sa_email}"
}

# Required for viewing secrets
resource "google_project_iam_member" "secret_viewer" {
  count   = length(var.secret_env_vars) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.viewer"
  member  = "serviceAccount:${local.cb_sa_email}"
}
