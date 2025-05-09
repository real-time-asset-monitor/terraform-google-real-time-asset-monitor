/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  service_name = "splitexport"
}

data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

resource "google_project_iam_member" "project_pubusb_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_service_account" "microservice_sa" {
  project      = var.project_id
  account_id   = local.service_name
  display_name = "RAM ${local.service_name}"
  description  = "Solution: Real-time Asset Monitor, microservice: ${local.service_name}"
}

resource "google_project_iam_member" "project_profiler_agent" {
  project = var.project_id
  role    = "roles/cloudprofiler.agent"
  member  = "serviceAccount:${google_service_account.microservice_sa.email}"
}

resource "google_storage_bucket_iam_member" "exports_admin" {
  bucket = var.exports_bucket_name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.microservice_sa.email}"
}

resource "google_pubsub_topic_iam_member" "cai_feed_publisher" {
  project = var.project_id
  topic   = var.cai_feed_topic_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.microservice_sa.email}"
}

resource "google_pubsub_topic_iam_member" "cai_feed_viewer" {
  project = var.project_id
  topic   = var.cai_feed_topic_id
  role    = "roles/pubsub.viewer"
  member  = "serviceAccount:${google_service_account.microservice_sa.email}"
}

resource "google_project_iam_member" "cloud_datastore_user" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.microservice_sa.email}"
}

resource "google_cloud_run_v2_service" "crun_svc" {
  project  = var.project_id
  name     = local.service_name
  location = var.crun_region
  client   = "terraform"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  template {
    containers {
      image = "${var.ram_container_images_registry}/${local.service_name}:${var.ram_microservice_image_tag}"
      resources {
        cpu_idle = true
        limits = {
          cpu    = var.crun_cpu
          memory = var.crun_memory
        }
      }
      env {
        name  = "${upper(local.service_name)}_CAI_FEED_TOPIC_ID"
        value = var.cai_feed_topic_id
      }
      env {
        name  = "${upper(local.service_name)}_ENVIRONMENT"
        value = var.environment
      }
      env {
        name  = "${upper(local.service_name)}_LOG_ONLY_SEVERITY_LEVELS"
        value = var.log_only_severity_levels
      }
      env {
        name  = "${upper(local.service_name)}_PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "${upper(local.service_name)}_START_PROFILER"
        value = var.start_profiler
      }
    }
    max_instance_request_concurrency = var.crun_concurrency
    timeout                          = var.crun_timeout
    service_account                  = google_service_account.microservice_sa.email
    scaling {
      max_instance_count = var.crun_max_instances
    }
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "google_pubsub_topic" "gcs_notif_export_topic" {
  project = var.project_id
  name    = var.gcs_notif_export_topic_name
  message_storage_policy {
    allowed_persistence_regions = var.pubsub_allowed_regions
  }
}

resource "google_storage_notification" "export_notification" {
  bucket         = var.exports_bucket_name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.gcs_notif_export_topic.id
  event_types    = ["OBJECT_FINALIZE"]
  custom_attributes = {
    notif-type = "caiexport"
  }
  depends_on = [google_project_iam_member.project_pubusb_publisher]
}

resource "google_service_account" "subscription_sa" {
  project      = var.project_id
  account_id   = "${local.service_name}-trigger"
  display_name = "RAM ${local.service_name} trigger"
  description  = "Solution: Real-time Asset Monitor, microservice trigger: ${local.service_name}"
}
data "google_iam_policy" "binding" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.subscription_sa.email}",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "trigger_invoker" {
  location = google_cloud_run_v2_service.crun_svc.location
  project  = google_cloud_run_v2_service.crun_svc.project
  service  = google_cloud_run_v2_service.crun_svc.name

  policy_data = data.google_iam_policy.binding.policy_data
}

resource "google_pubsub_subscription" "subcription" {
  project              = var.project_id
  name                 = local.service_name
  topic                = google_pubsub_topic.gcs_notif_export_topic.id
  ack_deadline_seconds = var.sub_ack_deadline_seconds
  push_config {
    oidc_token {
      service_account_email = google_service_account.subscription_sa.email
    }
    push_endpoint = "${google_cloud_run_v2_service.crun_svc.uri}/${google_pubsub_topic.gcs_notif_export_topic.id}"
  }
  expiration_policy {
    ttl = ""
  }
  filter                     = "attributes.notif-type = \"caiexport\""
  message_retention_duration = var.sub_message_retention_duration
  retry_policy {
    minimum_backoff = var.sub_minimum_backoff
  }
}
