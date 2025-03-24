## stack providers
#
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = ">= 5.76"
  }

  hcp = {
    source  = "hashicorp/hcp"
    version = ">= 0.100.0"
  }

  random = {
    source  = "hashicorp/random"
    version = ">= 3.6.3"
  }
}

provider "aws" "this" {
  for_each = var.regions

  config {
    region = each.value[1]

    assume_role_with_web_identity {
      role_arn           = "arn:aws:iam::563723692531:role/hcpt-workload-identity-ml4"
      web_identity_token = var.identity_token
    }

    default_tags {
      tags = var.common_tags
    }
  }
}

provider "aws" "hub-primary" {
  config {
    region = var.regions.primary[1]

    assume_role_with_web_identity {
      role_arn           = "arn:aws:iam::563723692531:role/hcpt-workload-identity-ml4"
      web_identity_token = var.identity_token
    }

    default_tags {
      tags = var.common_tags
    }
  }
}

provider "aws" "hub-secondary" {
  config {
    region = var.regions.secondary[1]

    assume_role_with_web_identity {
      role_arn           = "arn:aws:iam::563723692531:role/hcpt-workload-identity-ml4"
      web_identity_token = var.identity_token
    }

    default_tags {
      tags = var.common_tags
    }
  }
}

provider "aws" "spokes" {
  for_each = var.spokes

  config {
    region = each.value[1]

    assume_role_with_web_identity {
      role_arn           = "arn:aws:iam::563723692531:role/hcpt-workload-identity-ml4"
      web_identity_token = var.identity_token
    }

    default_tags {
      tags = var.common_tags
    }
  }
}

provider "hcp" "this" {
  config {
    client_id     = var.HCP_CLIENT_ID
    client_secret = var.HCP_CLIENT_SECRET
    project_id    = var.HCP_PROJECT_ID
  }
}

provider "random" "this" {}
