terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      version = ">= 4.0.0"
      source  = "hashicorp/aws"
    }
    # google = {
    #   source  = "hashicorp/google"
    #   version = ">= 5.34.0"
    # }
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = ">= 3.108.0"
    # }
    github = {
      source  = "integrations/github"
      version = ">= 5.42.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    tfe = {
      version = ">= 0.44.0"
      source  = "hashicorp/tfe"
    }
    tls = {
      version = ">= 4.0.0"
      source  = "hashicorp/tls"
    }
  }

  cloud {
    organization = "ml4"
    workspaces {
      name = "a-org-meta"
    }
  }
}

provider "tfe" {
  token = var.hcpt_token
}

## used to create repos backing LZ workspaces and those backing app team resource deployments
#
provider "github" {
  token = var.gh_token
}

provider "aws" {
  region = var.primary_region
  default_tags {
    tags = {
      Environment = var.common_tags.Env
      Owner       = var.common_tags.Owner
      Project     = var.common_tags.Project
      Name        = var.common_tags.Name
    }
  }
}

# provider "azurerm" {
#   environment = "public"
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false # set to `true` in prod
#     }
#   }
# }

# ## ensure GOOGLE_CREDENTIALS is correctly instantiated in the workspace
# #
# provider "google" {
#   region = var.gcp_region
# }

provider "null" {}
