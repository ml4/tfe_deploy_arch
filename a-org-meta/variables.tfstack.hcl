## common across components
#
variable "organization" {
  type        = string
  description = "Organization in HCPT"
}

variable "environment" {
  type        = string
  description = "dev, test, prod"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "lab aka app/project team name"
  default     = "lab"
}

variable "cloud" {
  type        = string
  description = "aws, azure, gcp, etc."
  default     = "aws"
}

variable "domain" {
  type        = string
  description = "domain"
  default     = "pi-ccn.org"
}

variable "regions" {
  type = map(list(string))
  default = {
    primary    = ["10.0.0.0/16", "eu-north-1"]
    secondary  = ["10.32.0.0/16", "eu-central-1"]
    tertiary   = ["10.64.0.0/16", "us-west-2"]
    quaternary = ["10.96.0.0/16", "ca-central-1"]
    quinary    = ["10.128.0.0/16", "ap-southeast-2"]
    senary     = ["10.160.0.0/16", "ap-northeast-1"]
  }
}

# Adding a region to this variable instructs HCP Terraform to remove it.
# variable "removed_regions" {
#     type = set(string)
# }

## kludge to get round early need-to-iterate-every-region-ness of stacks
#
variable "primary_region" {
  type = map(list(string))
  default = {
    primary = ["10.0.0.0/16", "eu-north-1"]
  }
}

variable "spokes" {
  type = map(list(string))
  default = {
    tertiary   = ["10.64.0.0/16", "us-west-2"]
    quaternary = ["10.96.0.0/16", "ca-central-1"]
    quinary    = ["10.128.0.0/16", "ap-southeast-2"]
    senary     = ["10.160.0.0/16", "ap-northeast-1"]
  }
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

## HCP
#
variable "HCP_CLIENT_ID" {
  type        = string
  description = "HCP client ID"
  sensitive   = false
  ephemeral   = true
}

variable "HCP_CLIENT_SECRET" {
  type        = string
  description = "HCP client secret"
  sensitive   = true
  ephemeral   = true
}

variable "HCP_PROJECT_ID" {
  type        = string
  description = "HCP project ID"
  sensitive   = false
  default     = "1479ff1d-4448-46cc-8e70-2c92408724ae"
}
