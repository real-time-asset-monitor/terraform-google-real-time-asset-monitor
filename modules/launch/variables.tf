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

variable "action_topic_name" {
  type        = string
  description = "the message body is the action to be executed"
  default     = "action"
}

variable "action_trigger_topic_name" {
  type        = string
  description = "the message body is the key used to fetch which actions to trigger"
  default     = "actionTrigger"
}

variable "pubsub_allowed_regions" {
  type        = list(string)
  description = "Pubsub allowed regions"
}

variable "schedulers" {
  type = map(any)
  default = {
    prd_every_week = {
      "environment" = "prd",
      "name"        = "at_01am10_on_sunday",
      "schedule"    = "10 1 * * 0",
    },
    prd_every_3h = {
      "environment" = "prd",
      "name"        = "at_minute_0_past_every_3rd_hour",
      "schedule"    = "0 */3 * * *",
    },
    qa_every_year = {
      "environment" = "qa",
      "name"        = "at_00am00_on_day_of_month_1_in_january",
      "schedule"    = "0 0 1 1 *",
    },
    qa_every_3h = {
      "environment" = "qa",
      "name"        = "at_minute_0_past_every_3rd_hour",
      "schedule"    = "0 */3 * * *",
    },
  }
  description = "schedulers"
}

variable "scheduler_region" {
  type        = string
  description = "Cloud Scheduler region"
  default     = "europe-west1"
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
