terraform {
  required_version = ">= 1.10.0"
  required_providers {
    github = {
      version = "<= 5.42.0"
      source  = "integrations/github"
    }
  }
}
