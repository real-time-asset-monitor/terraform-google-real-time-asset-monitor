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

variable "project_id" {
  type        = string
  description = "RAM GCP project id for a given environment, like dev or production"
}

variable "environment" {
  type        = string
  description = "environment name"
}

variable "gcs_location" {
  type        = string
  description = "Cloud Storage location"
  default     = "europe-west1"
}

variable "gcs_export_bucket_object_max_age_days" {
  type        = number
  description = "A lifecycle rule deletes objects older than this duration"
}

variable "export_org_ids" {
  description = "list of organization id where to grant Cloud Asset Inventory roles to allow export feature"
  type        = list(string)
}

variable "export_folder_ids" {
  description = "list of folder id where to grant Cloud Asset Inventory roles to allow export feature"
  type        = list(string)
}

variable "crun_region" {
  type        = string
  description = "cloud run region"
  default     = "europe-west1"
}

variable "crun_cpu" {
  type        = string
  description = "Number of cpu in k8s quantity 1000m means 1000 millicpu aka 1"
  default     = "1000m"
}
variable "crun_concurrency" {
  type        = number
  description = "Number of requests a container could received at the same time"
  default     = 80
}

variable "crun_max_instances" {
  type        = number
  description = "Max number of instances"
  default     = 10
}

variable "crun_memory" {
  type        = string
  description = "Memory allocation in k8s quantity "
  default     = "128Mi"
}


variable "crun_timeout" {
  type        = string
  description = "Max duration for an instance for responding to a request"
  default     = "180s"
}

variable "ram_container_images_registry" {
  type        = string
  description = "artifact registry path"
  default     = "europe-docker.pkg.dev/brunore-ram-dev-100/realtime-asset-monitor"
}

variable "ram_microservice_image_tag" {
  type        = string
  description = "The container image tag for this microservice"
  default     = "latest"
}

variable "log_only_severity_levels" {
  type        = string
  description = "Which type of log entry should be logged"
  default     = "WARNING NOTICE CRITICAL"
}

variable "start_profiler" {
  type        = string
  description = "Continuous CPU and heap profiling in Cloud Profiler"
  default     = "false"
}

variable "triggering_topic_id" {
  type        = string
  description = "Triggering topic e.g projects/PROJECT_ID/topics/TOPIC_NAME"
}

variable "sub_ack_deadline_seconds" {
  type        = number
  description = "The maximum time after a subscriber receives a message before the subscriber should acknowledge the message"
  default     = 10
}

variable "sub_message_retention_duration" {
  type        = string
  description = "How long to retain unacknowledged messages in the subscription's backlog,"
  default     = "86400s"
}

# https://cloud.google.com/asset-inventory/docs/quota
# 2022-02-11 ExportAsset quota is 60 per MINUTE -> do not retry in less than a minute
variable "sub_minimum_backoff" {
  type        = string
  description = "The minimum delay between consecutive deliveries of a given message"
  default     = "65s"
}
