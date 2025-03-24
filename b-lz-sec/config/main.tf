terraform {
  required_version = ">= 1.10.0"
  required_providers {
    github = {
      version = ">= 5.42.0"
      source  = "integrations/github"
    }
    tfe = {
      version = ">= 0.44.0"
      source  = "hashicorp/tfe"
    }
  }
  cloud {
    organization = "ml4"
    workspaces {
      name = "b-lz-sec"
    }
  }
}

provider "tfe" {
  token = var.hcpt_token
}

## used to create a repo backing app team workspaces
#
provider "github" {
  token = var.gh_token
}
