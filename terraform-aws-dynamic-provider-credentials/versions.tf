terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      version = ">= 5.0.0"
      source  = "hashicorp/aws"
    }
    tfe = {
      version = ">= 0.51.1"
      source  = "hashicorp/tfe"
    }
    tls = {
      version = ">= 4.0.0"
      source  = "hashicorp/tls"
    }
  }
}
