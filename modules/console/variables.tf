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
  default     = "60s"
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

variable "dns_name" {
  type        = string
  description = "The DNS name used to expose RAM e.g. ram.example.com"
}

variable "bff_connect_timeout_ms" {
  type        = number
  description = "Connection timeout to back for front in milliseconds"
  default     = 60000
}

variable "bff_receive_timeout_ms" {
  type        = number
  description = "Reveive timeout from back for front in milliseconds"
  default     = 60000
}
