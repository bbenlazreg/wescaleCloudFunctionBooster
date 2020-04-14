output "trigger_url" {
  value = "${google_cloudfunctions_function.app_function.https_trigger_url}"
}