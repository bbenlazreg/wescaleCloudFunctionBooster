locals {
  env = "prod"
}

provider "google" {
  project = "${var.project}"
}

module "functions" {
  source  = "../../modules/cloudFunctions"
  project = "${var.project}"
  env     = "${local.env}"
}