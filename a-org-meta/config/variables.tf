## locals - using locals to store the role arn created by the oidc deploy and write back as a project varset
## so that stacks can use it as a dynamic var as data sources not compatible with stacks yet.
#
# locals {
#   # google_credentials_var  = [for v in data.tfe_variables.all_variables.env : v if v.name == "GOOGLE_CREDENTIALS"]
#   # google_credentials_json = length(local.google_credentials_var) > 0 ? jsondecode(local.google_credentials_var[0].value) : {}
#   # project_id              = local.google_credentials_json.project_id
#   data_aws_iam_role =
# }

## common
#
variable "prefix" {
  type        = string
  description = "HCPT LZ workspace name prefix"
}

variable "organization" {
  type        = string
  description = "Organization in HCPT"
}

variable "hcpt_token" {
  type        = string
  description = "HCPT authentication token"
  sensitive   = true
}

variable "gh_token" {
  type        = string
  description = "GH authentication token used to auth the GH provider and to allow LZ GH repo deployment to fire workflow dispatch on the repo action to personalise to the LZ customer"
  sensitive   = true
}

variable "hcp_run_task_hmac" {
  type        = string
  description = "HCP Run Task authentication token"
  sensitive   = true
}

variable "tf_version" {
  type        = string
  description = "workspace Terraform core version"
}

## aws
#
variable "primary_region" {
  type        = string
  description = "Primary region"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

## route53 - Foundational Services - was env-svc-pipe
#
variable "hosted_zone" {
  type        = string
  description = "Chosen domain"
}

variable "gh_template_name" {
  type        = string
  description = "Template name to use for LZ deployment"
}

## multicloud subdomain delegation
#
# variable "azure_location" {
#   type        = string
#   description = "Azure location"
# }

# variable "gcp_project_id" {
#   type        = string
#   description = "GCP project"
# }

# variable "gcp_region" {
#   type        = string
#   description = "GCP region"
# }

## Global terraform variable set (not env vars) to enable clusters to get their pipeline secrets but tf passing the values to the user_data scripts
# ## As such the content needs to be set in every workspace to avoid the warnings,
# #
# variable "HCP_CLIENT_ID" {
#   type        = string
#   description = "HCP_CLIENT_ID for HVS vlt cli"
# }

# variable "HCP_CLIENT_SECRET" {
#   type        = string
#   description = "HCP_CLIENT_SECRET for HVS vlt cli"
# }

# variable "HCP_PROJECT_ID" {
#   type        = string
#   description = "HCP_PROJECT_ID for HVS vlt cli"
# }

# variable "HCP_ORGANIZATION_ID" {
#   type        = string
#   description = "HCP_ORGANIZATION_ID for HVS vlt cli"
# }

## added to appease workspace deployment as it created a var set in the a-org-meta project which for contained stacks use; removed as i need an explicit var set ID so need to put something explicit into the code to make it work.
#
# variable "oidc_role_arn" {
#   type        = string
#   description = "OIDC role ARN created by workspace run, and instantiated in a project var also created so that stacks can use the role associated with the workload identity deployment config for dynamic provider creds"
# }

