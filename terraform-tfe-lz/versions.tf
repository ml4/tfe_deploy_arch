terraform {
  required_version = ">= 1.10.0"
  required_providers {
    github = {
      version = ">= 5.42.0"
      source  = "integrations/github"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    tfe = {
      version = ">= 0.51.1"
      source  = "hashicorp/tfe"
    }
  }
}
