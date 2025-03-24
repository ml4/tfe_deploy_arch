## common
#
variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "organization" {
  description = "Organization name"
}

## mod_workspaces - MISSING tf_version so that new LZ mgmt workspaces get the latest version by default, and can be updated later by API and all extant mgmt LZ workspaces would need to be by the Platform Team were a TF zero-day to be discovered.
## Note also that we only go as far as this, in order to then inform the subordinate dev teams that a new version is available, and they can then update their own workspaces. This gives them some control over when to update.
## If, after we use the API to update the tf_version in all the LZ workspaces, we could also do am API-driven TF run of all of those and this would then update the dev team subordinate workspaces to the new tf version by force, in order to provide a failsafe.
#
variable "workspaces" {
  type        = list(string)
  description = "List of workspace names to create in this landing zone"
}

variable "hcpt_token" {
  type        = string
  description = "TFC API token used by the LZ to deploy more workspaces"
}

variable "gh_token" {
  type        = string
  description = "TFC API token used by the LZ to deploy more workspaces"
}
