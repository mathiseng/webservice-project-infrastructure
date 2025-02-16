# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "capable-sphinx-442212-k8"
  credentials = file("credentials.json")
  region = "europe-west1"
  zone = "europe-west1-b"
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
