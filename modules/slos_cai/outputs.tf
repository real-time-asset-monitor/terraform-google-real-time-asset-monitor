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


output "cai_custom_service_display_name" {
  value       = google_monitoring_custom_service.cai.display_name
  description = "Custom service display name"
}

output "cai_custom_service_id" {
  value       = google_monitoring_custom_service.cai.id
  description = "Custom service ID"
}

output "cai_monitoring_slo_latency" {
  value       = { for s in sort(keys(var.cai_latency)) : s => google_monitoring_slo.cai_latency[s].id }
  description = "SLO latency"
}

output "cai_monitoring_slo_latency_fast_burn_alert" {
  value       = { for s in sort(keys(var.cai_latency)) : s => google_monitoring_alert_policy.cai_latency_fast_burn[s].id }
  description = "Latency fast burn alert"
}

output "cai_monitoring_slo_latency_slow_burn_alert" {
  value       = { for s in sort(keys(var.cai_latency)) : s => google_monitoring_alert_policy.cai_latency_slow_burn[s].id }
  description = "Latency slow burn alert"
}

# output "slo" {
#   value = { for s in sort(keys(var.cai_latency)) : s => google_monitoring_slo.cai_latency[s] }
# }
