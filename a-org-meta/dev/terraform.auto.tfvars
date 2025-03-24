# LEGACY APPROACH WITH WORKSPACES TO DEPLOY TOP LEVEL OBJECTS AFTER API GENESIS. NOTE THIS IS NOW DONE BY a-org-meta STACK IN GITROOT.

tf_version = "1.10.0"

## TFC org
#
organization = "ml4"
prefix       = "b-lz"

## AWS dynamic credentials configuration
#
primary_region = "eu-north-1"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "ml4"
  "Name"    = "a-org-meta" # == namespace, top level workspace and project name
  "Project" = "platform"
}

## Route53 setup for the org
#
hosted_zone      = "pi-ccn.org"
gh_template_name = "terraform-template-lz-module"
# gcp_region       = "europe-west2"
# azure_location   = "westeurope"