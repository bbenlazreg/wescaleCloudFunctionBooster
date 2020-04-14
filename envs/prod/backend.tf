terraform {
  backend "gcs" {
    bucket = "sandbox-bbenlazreg-tfstate"
    prefix = "env/prod"
  }
}