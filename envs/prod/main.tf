locals {
  env = "prod"
  region = "europe-west1"
}

provider "google" {
  project = "${var.project}"
  region = "${local.region}"
}

module "functions" {
  source  = "../../modules/cloudFunctions"
  project = "${var.project}"
  env     = "${local.env}"
}