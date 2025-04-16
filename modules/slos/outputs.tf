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


output "ram_custom_service_display_name" {
  value       = google_monitoring_custom_service.ram.display_name
  description = "Custom service display name"
}

output "ram_custom_service_id" {
  value       = google_monitoring_custom_service.ram.id
  description = "Custom service Id"
}

output "ram_alerting_topic_id" {
  value       = google_pubsub_topic.alerting.id
  description = "Alerting topic Id"
}

output "ram_notification_channel_2pubsub_id" {
  value       = google_monitoring_notification_channel.alerting2pubsub.id
  description = "channel 2 pubsub id"
}

output "ram_notification_channels" {
  value       = local.notification_channels
  description = "Available notification channels"
}

output "ram_monitoring_slo_e2e_latency" {
  value       = { for s in sort(keys(var.ram_e2e_latency)) : s => google_monitoring_slo.ram_e2e_latency[s].id }
  description = "e2e latency"
}

output "ram_monitoring_slo_e2e_latency_fast_burn_alert" {
  value       = { for s in sort(keys(var.ram_e2e_latency)) : s => google_monitoring_alert_policy.ram_e2e_latency_fast_burn[s].id }
  description = "e2e latency fast burn alert"
}

output "ram_monitoring_slo_e2e_latency_slow_burn_alert" {
  value       = { for s in sort(keys(var.ram_e2e_latency)) : s => google_monitoring_alert_policy.ram_e2e_latency_slow_burn[s].id }
  description = "Slow burn alert"
}


output "ram_monitoring_slo_availability" {
  value       = { for s in sort(var.ram_availability.microservice_list) : s => google_monitoring_slo.ram_availability[s].id }
  description = "Ram monitoring slo availability"
}

output "ram_monitoring_slo_availability_fast_burn_alert" {
  value       = { for s in sort(var.ram_availability.microservice_list) : s => google_monitoring_alert_policy.ram_availability_fast_burn[s].id }
  description = "Availability fast burn alert"
}

output "ram_monitoring_slo_availability_slow_burn_alert" {
  value       = { for s in sort(var.ram_availability.microservice_list) : s => google_monitoring_alert_policy.ram_availability_slow_burn[s].id }
  description = "Availability slow burn alert"
}
