#output "project_number" {
#  value = data.google_project.project.number
#}
#output "cf_https_trigger_url" {
#  value = google_cloudfunctions_function.function_ingest.https_trigger_url 
#}
#output "Endpoint_API_URL" {
#  value  = google_cloud_run_service.cloud-run-ingest.status[0].url
#}
#output "PROJECT" {
#  value  = var.project
#}
#output "SERVICE" {
#  value = google_endpoints_service.ingest-api.service_name
#}
#output "CONFIG_ID" {
#  value = google_endpoints_service.ingest-api.config_id
#}
#output "IMAGE_BUILD_COMMAND" {
#value = "./gcloud_build_image_v${var.esp_version}.sh -s ${google_endpoints_service.ingest-api.service_name} -c ${google_endpoints_service.ingest-api.config_id} -p ${var.project}"
#}