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
  service_name = "publish2fs"
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
        name  = "${upper(local.service_name)}_ASSET_COLLECTION_ID"
        value = var.asset_collection_id
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

resource "google_service_account" "subscription_sa" {
  project      = var.project_id
  account_id   = "trigger-${local.service_name}"
  display_name = "RAM execute ${local.service_name} trigger"
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
  topic                = var.triggering_topic_id
  ack_deadline_seconds = var.sub_ack_deadline_seconds
  push_config {
    oidc_token {
      service_account_email = google_service_account.subscription_sa.email
    }
    push_endpoint = "${google_cloud_run_v2_service.crun_svc.uri}/${var.triggering_topic_id}"
  }
  expiration_policy {
    ttl = ""
  }
  filter                     = "attributes.publish2fs=\"true\""
  message_retention_duration = var.sub_message_retention_duration
  retry_policy {
    minimum_backoff = var.sub_minimum_backoff
  }
}

module "gcloud" {
  count   = var.deploy_fs_assets_retention_policy == true ? 1 : 0
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.4"

  platform              = "linux"
  additional_components = ["beta"]

  create_cmd_entrypoint = "gcloud"
  create_cmd_body       = "firestore fields ttls update expireAt --collection-group=${var.asset_collection_id} --enable-ttl --project=${var.project_id}"
}
