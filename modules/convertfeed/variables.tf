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

variable "cai_feed_topic_name" {
  type        = string
  description = "google cloud asset inventory feed messages"
  default     = "caiFeed"
}

variable "asset_feed_topic_name" {
  type        = string
  description = "the data on which to assess compliance"
  default     = "assetFeed"
}

variable "pubsub_allowed_regions" {
  type        = list(string)
  description = "Pubsub allowed regions"
}

variable "gcs_location" {
  type        = string
  description = "Cloud Storage location"
  default     = "europe-west1"
}

variable "crun_region" {
  type        = string
  description = "cloud run region"
  default     = "europe-west1"
}

variable "crun_cpu" {
  type        = string
  description = "Number of cpu in k8s quantity 1000m means 1000 millicpu aka 1"
  default     = "2000m"
}
variable "crun_concurrency" {
  type        = number
  description = "Number of requests a container could received at the same time"
  default     = 200
}

variable "crun_max_instances" {
  type        = number
  description = "Max number of instances"
  default     = 1000
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
variable "asset_collection_id" {
  type        = string
  description = "firestore assets collection id"
  default     = "assets"
}
variable "cache_max_age_minutes" {
  type        = string
  description = "Duration in minutes after which the asset cache should be reloaded"
  default     = "60"
}
variable "log_only_severity_levels" {
  type        = string
  description = "Which type of log entry should be logged"
  default     = "WARNING NOTICE CRITICAL"
}
variable "owner_label_key_name" {
  type        = string
  description = "violation owner label tag name"
  default     = "owner"
}
variable "start_profiler" {
  type        = string
  description = "Continuous CPU and heap profiling in Cloud Profiler"
  default     = "false"
}
variable "violation_resolver_label_key_name" {
  type        = string
  description = "violation resolver label tag name"
  default     = "resolver"
}
