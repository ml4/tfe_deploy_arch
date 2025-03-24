#terraform-tfe-hc-policy-set
resource "tfe_policy_set" "main" {
  name          = var.policy_name
  description   = var.policy_description
  organization  = var.policy_organization
  policies_path = var.policy_path
  global        = var.global ? var.global : null
  workspace_ids = length(var.workspace_ids) > 0 ? var.workspace_ids : null
  # workspace_ids = ["${tfe_workspace.main.id}"]

  vcs_repo {
    identifier         = var.policy_repository
    branch             = var.policy_repository_branch
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
    # oauth_token_id     = "${tfe_oauth_client.main.id}"
  }
}
