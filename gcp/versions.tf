terraform {
  required_version = ">= 0.13.0"

  required_providers {
    gcp = {
      source  = "hashicorp/gcp"
      version = ">= 3.0.0"
    }
  }
}
