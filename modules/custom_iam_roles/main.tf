# ==============================================================================
# Custom IAM Roles Module
# Creates project-specific IAM roles for different team members
# ==============================================================================

# ------------------------------------------------------------------------------
# Developer Role
# For developers who need to view logs, metrics, and debug issues
# Read-only access - cannot modify infrastructure
# ------------------------------------------------------------------------------
resource "google_project_iam_custom_role" "developer" {
  role_id     = "${var.role_prefix}_developer"
  title       = "${var.project_name} Developer"
  description = "Read-only access for developers to view logs, metrics, and Cloud Run status"
  project     = var.project_id

  permissions = [
    # Cloud Run - View only
    "run.services.get",
    "run.services.list",
    "run.revisions.get",
    "run.revisions.list",
    "run.locations.list",
    "run.routes.get",
    "run.routes.list",
    "run.configurations.get",
    "run.configurations.list",

    # Logging - View logs
    "logging.views.access",
    "logging.logEntries.list",
    "logging.logs.list",
    "logging.logServices.list",
    "logging.logServiceIndexes.list",

    # Monitoring - View metrics
    "monitoring.metricDescriptors.get",
    "monitoring.metricDescriptors.list",
    "monitoring.monitoredResourceDescriptors.get",
    "monitoring.monitoredResourceDescriptors.list",
    "monitoring.timeSeries.list",
    "monitoring.dashboards.get",
    "monitoring.dashboards.list",
    "monitoring.alertPolicies.get",
    "monitoring.alertPolicies.list",
    "monitoring.groups.get",
    "monitoring.groups.list",

    # Cloud Build - View builds
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",

    # Artifact Registry - View images
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
    "artifactregistry.packages.get",
    "artifactregistry.packages.list",
    "artifactregistry.versions.get",
    "artifactregistry.versions.list",
    "artifactregistry.tags.get",
    "artifactregistry.tags.list",

    # BigQuery - View data (no modification)
    "bigquery.datasets.get",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "bigquery.jobs.get",
    "bigquery.jobs.list",

    # Pub/Sub - View topics
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list",

    # Firestore - Read data
    "datastore.entities.get",
    "datastore.entities.list",

    # Resource Manager
    "resourcemanager.projects.get",
  ]
}

# ------------------------------------------------------------------------------
# DevOps Role
# For DevOps engineers who manage deployments and infrastructure
# Can deploy, manage builds, view secrets (not modify)
# ------------------------------------------------------------------------------
resource "google_project_iam_custom_role" "devops" {
  role_id     = "${var.role_prefix}_devops"
  title       = "${var.project_name} DevOps Engineer"
  description = "Deploy and manage Cloud Run services, builds, and view infrastructure"
  project     = var.project_id

  permissions = [
    # Cloud Run - Full management
    "run.services.get",
    "run.services.list",
    "run.services.create",
    "run.services.update",
    "run.services.delete",
    "run.revisions.get",
    "run.revisions.list",
    "run.revisions.delete",
    "run.locations.list",
    "run.routes.get",
    "run.routes.list",
    "run.configurations.get",
    "run.configurations.list",
    "run.executions.get",
    "run.executions.list",
    "run.executions.delete",
    "run.jobs.get",
    "run.jobs.list",
    "run.jobs.run",
    "run.operations.get",
    "run.operations.list",

    # IAM for Cloud Run
    "run.services.getIamPolicy",
    "run.services.setIamPolicy",

    # Cloud Build - Full management
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudbuild.builds.create",
    "cloudbuild.builds.update",
    "cloudbuild.workerpools.get",
    "cloudbuild.workerpools.list",

    # Artifact Registry - Full management
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
    "artifactregistry.repositories.downloadArtifacts",
    "artifactregistry.repositories.uploadArtifacts",
    "artifactregistry.packages.get",
    "artifactregistry.packages.list",
    "artifactregistry.packages.delete",
    "artifactregistry.versions.get",
    "artifactregistry.versions.list",
    "artifactregistry.versions.delete",
    "artifactregistry.tags.get",
    "artifactregistry.tags.list",
    "artifactregistry.tags.create",
    "artifactregistry.tags.update",
    "artifactregistry.tags.delete",

    # Secret Manager - View only (cannot modify secrets)
    "secretmanager.secrets.get",
    "secretmanager.secrets.list",
    "secretmanager.versions.get",
    "secretmanager.versions.list",
    "secretmanager.versions.access",

    # Logging
    "logging.views.access",
    "logging.logEntries.list",
    "logging.logEntries.create",
    "logging.logs.list",
    "logging.logServices.list",

    # Monitoring - Full access
    "monitoring.metricDescriptors.get",
    "monitoring.metricDescriptors.list",
    "monitoring.timeSeries.list",
    "monitoring.timeSeries.create",
    "monitoring.dashboards.get",
    "monitoring.dashboards.list",
    "monitoring.alertPolicies.get",
    "monitoring.alertPolicies.list",
    "monitoring.groups.get",
    "monitoring.groups.list",
    "monitoring.uptimeCheckConfigs.get",
    "monitoring.uptimeCheckConfigs.list",

    # Cloud Scheduler
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.list",
    "cloudscheduler.jobs.run",
    "cloudscheduler.jobs.pause",

    # Pub/Sub
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.topics.publish",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list",
    "pubsub.subscriptions.consume",

    # BigQuery - Read and run jobs
    "bigquery.datasets.get",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "bigquery.tables.getData",
    "bigquery.jobs.get",
    "bigquery.jobs.list",
    "bigquery.jobs.create",

    # Firestore
    "datastore.entities.get",
    "datastore.entities.list",

    # Service Accounts - Use for deployment
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",

    # Resource Manager
    "resourcemanager.projects.get",
  ]
}

# ------------------------------------------------------------------------------
# Platform Admin Role
# For platform administrators who manage all infrastructure
# Full access to IP resources (not project-level admin)
# ------------------------------------------------------------------------------
resource "google_project_iam_custom_role" "platform_admin" {
  role_id     = "${var.role_prefix}_platform_admin"
  title       = "${var.project_name} Platform Admin"
  description = "Full access to manage all project infrastructure"
  project     = var.project_id

  permissions = [
    # Cloud Run - Full
    "run.services.get",
    "run.services.list",
    "run.services.create",
    "run.services.update",
    "run.services.delete",
    "run.services.getIamPolicy",
    "run.services.setIamPolicy",
    "run.revisions.get",
    "run.revisions.list",
    "run.revisions.delete",
    "run.locations.list",
    "run.routes.get",
    "run.routes.list",
    "run.configurations.get",
    "run.configurations.list",
    "run.executions.get",
    "run.executions.list",
    "run.executions.delete",
    "run.jobs.get",
    "run.jobs.list",
    "run.jobs.create",
    "run.jobs.update",
    "run.jobs.delete",
    "run.jobs.run",
    "run.operations.get",
    "run.operations.list",

    # Cloud Build - Full
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudbuild.builds.create",
    "cloudbuild.builds.update",
    "cloudbuild.workerpools.get",
    "cloudbuild.workerpools.list",
    "cloudbuild.workerpools.create",
    "cloudbuild.workerpools.update",
    "cloudbuild.workerpools.delete",

    # Secret Manager - Full
    "secretmanager.secrets.get",
    "secretmanager.secrets.list",
    "secretmanager.secrets.create",
    "secretmanager.secrets.update",
    "secretmanager.secrets.delete",
    "secretmanager.versions.get",
    "secretmanager.versions.list",
    "secretmanager.versions.access",
    "secretmanager.versions.add",
    "secretmanager.versions.enable",
    "secretmanager.versions.disable",
    "secretmanager.versions.destroy",

    # KMS - Full
    "cloudkms.keyRings.get",
    "cloudkms.keyRings.list",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.list",
    "cloudkms.cryptoKeyVersions.get",
    "cloudkms.cryptoKeyVersions.list",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.cryptoKeyVersions.useToDecrypt",

    # Artifact Registry - Full
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
    "artifactregistry.repositories.create",
    "artifactregistry.repositories.update",
    "artifactregistry.repositories.delete",
    "artifactregistry.repositories.downloadArtifacts",
    "artifactregistry.repositories.uploadArtifacts",
    "artifactregistry.packages.get",
    "artifactregistry.packages.list",
    "artifactregistry.packages.delete",
    "artifactregistry.versions.get",
    "artifactregistry.versions.list",
    "artifactregistry.versions.delete",
    "artifactregistry.tags.get",
    "artifactregistry.tags.list",
    "artifactregistry.tags.create",
    "artifactregistry.tags.update",
    "artifactregistry.tags.delete",

    # Logging - Full
    "logging.views.access",
    "logging.logEntries.list",
    "logging.logEntries.create",
    "logging.logs.list",
    "logging.logs.delete",
    "logging.sinks.get",
    "logging.sinks.list",
    "logging.sinks.create",
    "logging.sinks.update",
    "logging.sinks.delete",

    # Monitoring - Full
    "monitoring.metricDescriptors.get",
    "monitoring.metricDescriptors.list",
    "monitoring.metricDescriptors.create",
    "monitoring.timeSeries.list",
    "monitoring.timeSeries.create",
    "monitoring.dashboards.get",
    "monitoring.dashboards.list",
    "monitoring.dashboards.create",
    "monitoring.dashboards.update",
    "monitoring.dashboards.delete",
    "monitoring.alertPolicies.get",
    "monitoring.alertPolicies.list",
    "monitoring.alertPolicies.create",
    "monitoring.alertPolicies.update",
    "monitoring.alertPolicies.delete",
    "monitoring.notificationChannels.get",
    "monitoring.notificationChannels.list",
    "monitoring.notificationChannels.create",
    "monitoring.notificationChannels.update",
    "monitoring.notificationChannels.delete",
    "monitoring.uptimeCheckConfigs.get",
    "monitoring.uptimeCheckConfigs.list",
    "monitoring.uptimeCheckConfigs.create",
    "monitoring.uptimeCheckConfigs.update",
    "monitoring.uptimeCheckConfigs.delete",
    "monitoring.groups.get",
    "monitoring.groups.list",
    "monitoring.groups.create",
    "monitoring.groups.update",
    "monitoring.groups.delete",

    # Cloud Scheduler - Full
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.list",
    "cloudscheduler.jobs.create",
    "cloudscheduler.jobs.update",
    "cloudscheduler.jobs.delete",
    "cloudscheduler.jobs.run",
    "cloudscheduler.jobs.pause",

    # Pub/Sub - Full
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.topics.create",
    "pubsub.topics.update",
    "pubsub.topics.delete",
    "pubsub.topics.publish",
    "pubsub.topics.getIamPolicy",
    "pubsub.topics.setIamPolicy",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list",
    "pubsub.subscriptions.create",
    "pubsub.subscriptions.update",
    "pubsub.subscriptions.delete",
    "pubsub.subscriptions.consume",
    "pubsub.subscriptions.getIamPolicy",
    "pubsub.subscriptions.setIamPolicy",

    # BigQuery - Full
    "bigquery.datasets.get",
    "bigquery.datasets.getIamPolicy",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "bigquery.tables.getData",
    "bigquery.tables.updateData",
    "bigquery.jobs.get",
    "bigquery.jobs.list",
    "bigquery.jobs.create",

    # Firestore - Full
    "datastore.databases.get",
    "datastore.entities.get",
    "datastore.entities.list",
    "datastore.entities.create",
    "datastore.entities.update",
    "datastore.entities.delete",
    "datastore.indexes.get",
    "datastore.indexes.list",

    # DNS - Full
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "dns.resourceRecordSets.create",
    "dns.resourceRecordSets.update",
    "dns.resourceRecordSets.delete",
    "dns.managedZones.get",
    "dns.managedZones.list",

    # Load Balancers
    "compute.regionUrlMaps.get",
    "compute.regionUrlMaps.list",
    "compute.regionBackendServices.get",
    "compute.regionBackendServices.list",
    "compute.forwardingRules.get",
    "compute.forwardingRules.list",
    "compute.regionTargetHttpsProxies.get",
    "compute.regionTargetHttpsProxies.list",
    "compute.regionNetworkEndpointGroups.get",
    "compute.regionNetworkEndpointGroups.list",

    # Service Accounts
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.getIamPolicy",

    # Resource Manager
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
  ]
}

# ------------------------------------------------------------------------------
# Viewer Role
# For stakeholders who need read-only access to view dashboards and status
# ------------------------------------------------------------------------------
resource "google_project_iam_custom_role" "viewer" {
  role_id     = "${var.role_prefix}_viewer"
  title       = "${var.project_name} Viewer"
  description = "Read-only access to view dashboards, metrics, and status"
  project     = var.project_id

  permissions = [
    # Cloud Run - View only
    "run.services.get",
    "run.services.list",
    "run.revisions.list",
    "run.locations.list",

    # Monitoring - View dashboards
    "monitoring.dashboards.get",
    "monitoring.dashboards.list",
    "monitoring.timeSeries.list",
    "monitoring.metricDescriptors.list",
    "monitoring.alertPolicies.list",

    # Logging - View logs
    "logging.logEntries.list",
    "logging.logs.list",

    # BigQuery - View metadata
    "bigquery.datasets.get",
    "bigquery.tables.list",

    # Resource Manager
    "resourcemanager.projects.get",
  ]
}

# ------------------------------------------------------------------------------
# Data Analyst Role
# For data analysts - BigQuery, Firestore, Vertex AI, Cloud Run, Scheduler, Pub/Sub
# ------------------------------------------------------------------------------
resource "google_project_iam_custom_role" "data_analyst" {
  role_id     = "${var.role_prefix}_data_analyst"
  title       = "${var.project_name} Data Analyst"
  description = "Full access to BigQuery, Firestore, Vertex AI, Cloud Run, Scheduler, Pub/Sub for data analysis and ML"
  project     = var.project_id

  permissions = [
    # =========================================================================
    # BigQuery - Full read + write + job execution
    # =========================================================================
    "bigquery.datasets.get",
    "bigquery.datasets.getIamPolicy",
    "bigquery.datasets.create",
    "bigquery.datasets.update",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "bigquery.tables.getData",
    "bigquery.tables.export",
    "bigquery.tables.create",
    "bigquery.tables.update",
    "bigquery.tables.updateData",
    "bigquery.tables.delete",
    "bigquery.jobs.get",
    "bigquery.jobs.list",
    "bigquery.jobs.create",
    "bigquery.savedqueries.get",
    "bigquery.savedqueries.list",
    "bigquery.savedqueries.create",
    "bigquery.savedqueries.update",

    # =========================================================================
    # Firestore - Full read + write + create
    # =========================================================================
    "datastore.databases.get",
    "datastore.databases.list",
    "datastore.entities.get",
    "datastore.entities.list",
    "datastore.entities.create",
    "datastore.entities.update",
    "datastore.entities.delete",
    "datastore.indexes.get",
    "datastore.indexes.list",
    "datastore.indexes.create",
    "datastore.indexes.delete",
    "datastore.namespaces.get",
    "datastore.namespaces.list",
    "datastore.statistics.get",
    "datastore.statistics.list",

    # =========================================================================
    # Pub/Sub - Full read + write + create
    # =========================================================================
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.topics.create",
    "pubsub.topics.update",
    "pubsub.topics.delete",
    "pubsub.topics.publish",
    "pubsub.topics.attachSubscription",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list",
    "pubsub.subscriptions.create",
    "pubsub.subscriptions.update",
    "pubsub.subscriptions.delete",
    "pubsub.subscriptions.consume",
    "pubsub.snapshots.get",
    "pubsub.snapshots.list",
    "pubsub.snapshots.create",
    "pubsub.schemas.get",
    "pubsub.schemas.list",
    "pubsub.schemas.create",
    "pubsub.schemas.validate",

    # =========================================================================
    # Cloud Run - View + invoke
    # =========================================================================
    "run.services.get",
    "run.services.list",
    "run.revisions.get",
    "run.revisions.list",
    "run.locations.list",
    "run.routes.get",
    "run.routes.list",
    "run.configurations.get",
    "run.configurations.list",
    "run.jobs.get",
    "run.jobs.list",
    "run.jobs.run",
    "run.executions.get",
    "run.executions.list",

    # =========================================================================
    # Cloud Scheduler - Full CRUD
    # =========================================================================
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.list",
    "cloudscheduler.jobs.create",
    "cloudscheduler.jobs.update",
    "cloudscheduler.jobs.delete",
    "cloudscheduler.jobs.run",
    "cloudscheduler.jobs.pause",
    "cloudscheduler.locations.get",
    "cloudscheduler.locations.list",

    # =========================================================================
    # Vertex AI - Full ML/AI Access
    # =========================================================================
    # Datasets
    "aiplatform.datasets.get",
    "aiplatform.datasets.list",
    "aiplatform.datasets.create",
    "aiplatform.datasets.update",
    "aiplatform.datasets.delete",
    "aiplatform.datasets.export",
    "aiplatform.datasets.import",

    # Models
    "aiplatform.models.get",
    "aiplatform.models.list",
    "aiplatform.models.upload",
    "aiplatform.models.update",
    "aiplatform.models.delete",
    "aiplatform.models.export",
    "aiplatform.modelEvaluations.get",
    "aiplatform.modelEvaluations.list",
    "aiplatform.modelEvaluationSlices.get",
    "aiplatform.modelEvaluationSlices.list",

    # Training
    "aiplatform.trainingPipelines.get",
    "aiplatform.trainingPipelines.list",
    "aiplatform.trainingPipelines.create",
    "aiplatform.trainingPipelines.cancel",
    "aiplatform.trainingPipelines.delete",
    "aiplatform.customJobs.get",
    "aiplatform.customJobs.list",
    "aiplatform.customJobs.create",
    "aiplatform.customJobs.cancel",
    "aiplatform.customJobs.delete",
    "aiplatform.hyperparameterTuningJobs.get",
    "aiplatform.hyperparameterTuningJobs.list",
    "aiplatform.hyperparameterTuningJobs.create",
    "aiplatform.hyperparameterTuningJobs.cancel",
    "aiplatform.hyperparameterTuningJobs.delete",

    # Endpoints & Predictions
    "aiplatform.endpoints.get",
    "aiplatform.endpoints.list",
    "aiplatform.endpoints.create",
    "aiplatform.endpoints.update",
    "aiplatform.endpoints.delete",
    "aiplatform.endpoints.predict",
    "aiplatform.endpoints.explain",

    # Batch Predictions
    "aiplatform.batchPredictionJobs.get",
    "aiplatform.batchPredictionJobs.list",
    "aiplatform.batchPredictionJobs.create",
    "aiplatform.batchPredictionJobs.cancel",
    "aiplatform.batchPredictionJobs.delete",

    # Pipelines
    "aiplatform.pipelineJobs.get",
    "aiplatform.pipelineJobs.list",
    "aiplatform.pipelineJobs.create",
    "aiplatform.pipelineJobs.cancel",
    "aiplatform.pipelineJobs.delete",

    # Feature Store
    "aiplatform.featurestores.get",
    "aiplatform.featurestores.list",
    "aiplatform.featurestores.create",
    "aiplatform.featurestores.update",
    "aiplatform.entityTypes.get",
    "aiplatform.entityTypes.list",
    "aiplatform.entityTypes.create",
    "aiplatform.entityTypes.update",
    "aiplatform.features.get",
    "aiplatform.features.list",
    "aiplatform.features.create",
    "aiplatform.features.update",

    # Experiments & Metadata
    "aiplatform.metadataStores.get",
    "aiplatform.metadataStores.list",
    "aiplatform.metadataStores.create",
    "aiplatform.artifacts.get",
    "aiplatform.artifacts.list",
    "aiplatform.artifacts.create",
    "aiplatform.artifacts.update",
    "aiplatform.contexts.get",
    "aiplatform.contexts.list",
    "aiplatform.contexts.create",
    "aiplatform.executions.get",
    "aiplatform.executions.list",
    "aiplatform.executions.create",

    # Notebooks (Workbench) - using notebooks API
    "notebooks.instances.get",
    "notebooks.instances.list",
    "notebooks.instances.create",
    "notebooks.instances.delete",
    "notebooks.instances.start",
    "notebooks.instances.stop",
    "notebooks.locations.get",
    "notebooks.locations.list",
    "notebooks.operations.get",
    "notebooks.operations.list",
    "notebooks.runtimes.get",
    "notebooks.runtimes.list",

    # Tensorboards
    "aiplatform.tensorboards.get",
    "aiplatform.tensorboards.list",
    "aiplatform.tensorboards.create",
    "aiplatform.tensorboards.update",
    "aiplatform.tensorboardExperiments.get",
    "aiplatform.tensorboardExperiments.list",
    "aiplatform.tensorboardExperiments.create",
    "aiplatform.tensorboardRuns.get",
    "aiplatform.tensorboardRuns.list",
    "aiplatform.tensorboardRuns.create",
    "aiplatform.tensorboardTimeSeries.get",
    "aiplatform.tensorboardTimeSeries.list",
    "aiplatform.tensorboardTimeSeries.create",

    # Model Monitoring
    "aiplatform.modelDeploymentMonitoringJobs.get",
    "aiplatform.modelDeploymentMonitoringJobs.list",
    "aiplatform.modelDeploymentMonitoringJobs.create",

    # Vector Search (Index)
    "aiplatform.indexes.get",
    "aiplatform.indexes.list",
    "aiplatform.indexes.create",
    "aiplatform.indexes.update",
    "aiplatform.indexEndpoints.get",
    "aiplatform.indexEndpoints.list",
    "aiplatform.indexEndpoints.create",
    "aiplatform.indexEndpoints.update",



    # =========================================================================
    # Cloud Storage - For model artifacts and data
    # =========================================================================
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.create",
    "storage.objects.update",
    "storage.objects.delete",

    # =========================================================================
    # Monitoring - View metrics for analysis
    # =========================================================================
    "monitoring.timeSeries.list",
    "monitoring.metricDescriptors.list",
    "monitoring.dashboards.get",
    "monitoring.dashboards.list",

    # =========================================================================
    # Logging - View logs
    # =========================================================================
    "logging.logEntries.list",
    "logging.logs.list",

    # =========================================================================
    # Resource Manager
    # =========================================================================
    "resourcemanager.projects.get",
  ]
}

# ------------------------------------------------------------------------------
# IAM Bindings for Team Members (Optional - can be enabled per member)
# ------------------------------------------------------------------------------

# Developer bindings
resource "google_project_iam_member" "developers" {
  for_each = toset(var.developers)

  project = var.project_id
  role    = google_project_iam_custom_role.developer.id
  member  = each.value
}

# DevOps bindings
resource "google_project_iam_member" "devops" {
  for_each = toset(var.devops_engineers)

  project = var.project_id
  role    = google_project_iam_custom_role.devops.id
  member  = each.value
}

# Platform Admin bindings
resource "google_project_iam_member" "platform_admins" {
  for_each = toset(var.platform_admins)

  project = var.project_id
  role    = google_project_iam_custom_role.platform_admin.id
  member  = each.value
}

# Viewer bindings
resource "google_project_iam_member" "viewers" {
  for_each = toset(var.viewers)

  project = var.project_id
  role    = google_project_iam_custom_role.viewer.id
  member  = each.value
}

# Data Analyst bindings
resource "google_project_iam_member" "data_analysts" {
  for_each = toset(var.data_analysts)

  project = var.project_id
  role    = google_project_iam_custom_role.data_analyst.id
  member  = each.value
}

