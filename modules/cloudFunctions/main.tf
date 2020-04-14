# zip source code
data "archive_file" "app_zip" {
 type        = "zip"
 source_dir  = "${path.root}/../../app/"
 output_path = "${path.root}/../../app/app.zip"
}

# function storage bucket
resource "google_storage_bucket" "app_bucket" {
 name   = "app_bucket_${var.project}"
}

# copy zip to bucket
resource "google_storage_bucket_object" "app_zip" {
 name   = "${var.env}/app.zip"
 bucket = "${google_storage_bucket.app_bucket.name}"
 source = "${path.root}/../../app/app.zip"
}

# cloud function
resource "google_cloudfunctions_function" "app_function" {
 name                  = "app-function-${var.env}"
 description           = "App Function"
 available_memory_mb   = 256
 source_archive_bucket = "${google_storage_bucket.app_bucket.name}"
 source_archive_object = "${google_storage_bucket_object.app_zip.name}"
 timeout               = 60
 entry_point           = "helloWorld"
 trigger_http          = true
 runtime               = "nodejs10"
}

