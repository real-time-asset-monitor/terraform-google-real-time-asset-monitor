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

variable "notification_channels" {
  type        = list(string)
  description = "Available notification channels"
}

variable "alerting_topic_name" {
  type        = string
  default     = "alerting"
  description = "Alerting topic name used by RAM"
}

variable "pubsub_allowed_regions" {
  type        = list(string)
  description = "List of pubsub allowed regions"
}

variable "ram_e2e_latency" {
  type        = map(any)
  description = "ram_e2e_latency"
}

variable "log_metric_ram_execution_count_id" {
  type        = number
  description = "count id RAM execution"
}

variable "log_metric_ram_execution_latency_e2e_id" {
  type        = number
  description = "Latency for e2e in seconds"
}

variable "ram_availability" {
  type = object({
    microservice_list                  = list(string)
    goal                               = number
    rolling_period_days                = number
    alerting_fast_burn_loopback_period = string
    alerting_fast_burn_threshold       = number
    alerting_slow_burn_loopback_period = string
    alerting_slow_burn_threshold       = number
  })
  description = "Critical User Journeys CUJs map crtical microservices"
  default = {
    microservice_list = [
      "launch",
      "execute",
      "splitexport",
      "convertfeed",
      "fetchrules",
      "monitor",
      "stream2bq",
      "publish2fs"
    ]
    goal                               = 0.999
    rolling_period_days                = 28
    alerting_fast_burn_loopback_period = "1h"
    alerting_fast_burn_threshold       = 10
    alerting_slow_burn_loopback_period = "24h"
    alerting_slow_burn_threshold       = 2
  }
}
