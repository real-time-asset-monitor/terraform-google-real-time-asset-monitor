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

output "project_id" {
  value       = var.project_id
  description = "Project id"
}

output "convertfeed" {
  value       = module.convertfeed
  description = "convertfeed module"
}

output "dashboards" {
  value       = module.dashboards
  description = "dashboards module"
}

output "deploy" {
  value       = module.deploy
  description = "deploy"
}

output "executecaiexport" {
  value       = module.executecaiexport
  description = "executecaiexport"
}

output "executegfsdeleteolddocs" {
  value       = module.executegfsdeleteolddocs
  description = "executegfsdeleteolddocs"
}

# output "feeds" {
#   value       = module.feeds
# }

output "fetchrules" {
  value       = module.fetchrules
  description = "fetchrules"
}

output "launch" {
  value       = module.launch
  description = "launch"
}

output "metrics" {
  value       = module.metrics
  description = "metrics"
}

output "monitor" {
  value       = module.monitor
  description = "monitor"
}

output "publish2fs" {
  value       = module.publish2fs
  description = "Module publish2fs"
}

output "slos" {
  value       = module.slos
  description = "slos"
}

output "slos_cai" {
  value       = module.slos_cai
  description = "slos cai"
}

output "splitexport" {
  value       = module.splitexport
  description = "RAM split export"
}

output "stream2bq" {
  value       = module.stream2bq
  description = "Stream2bq module"
}

output "transparentslis" {
  value       = module.transparentslis
  description = "Transparentslis module"
}

output "upload2gcs" {
  value       = module.upload2gcs
  description = "upload2gcs module"
}

output "autofixbqdsdelete" {
  value       = module.autofixbqdsdelete
  description = "autofixbqdsdelete module"
}

output "console" {
  value       = module.console
  description = "console module"
}

output "consolebff" {
  value       = module.consolebff
  description = "consolebff module"
}

output "loadbalancer" {
  value       = module.loadbalancer
  description = "loadbalancer module"
}
