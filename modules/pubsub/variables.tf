# ==============================================================================
# Pub/Sub Module - Variables
# ==============================================================================

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "topics" {
  description = "List of Pub/Sub topics to create"
  type = list(object({
    name                       = string
    description                = optional(string, "Managed by Terraform")
    message_retention_duration = optional(string, "604800s")
    enable_dead_letter         = optional(bool, false)
  }))
  default = []
}

variable "subscriptions" {
  description = "List of Pub/Sub subscriptions to create"
  type = list(object({
    name                       = string
    topic                      = string
    description                = optional(string, "Managed by Terraform")
    push_endpoint              = optional(string, "")
    push_service_account       = optional(string, "")
    ack_deadline_seconds       = optional(number, 10)
    message_retention_duration = optional(string, "604800s")
    retain_acked_messages      = optional(bool, false)
    expiration_ttl             = optional(string, "2678400s")
    retry_minimum_backoff      = optional(string, "10s")
    retry_maximum_backoff      = optional(string, "600s")
    enable_message_ordering    = optional(bool, false)
    filter                     = optional(string, null)
    bigquery_config = optional(object({
      table               = string
      write_metadata      = optional(bool, false)
      drop_unknown_fields = optional(bool, false)
    }), null)
  }))
  default = []
}

variable "publisher_members" {
  description = "List of members to grant Pub/Sub Publisher role on all topics"
  type        = list(string)
  default     = []
}

variable "subscriber_members" {
  description = "List of members to grant Pub/Sub Subscriber role on all subscriptions"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}


