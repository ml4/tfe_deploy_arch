## main.tf terraform configuration
#
## VARIABLE SETS for dynamic creds and hcpp machine images are now set global from the a-org-platform level.
## NOTE: the var set to allow machines hydrated in app team repos to use vlt to extract secrets from HVS is not set from a-org-platform as not all workspaces need these terraform vars. They need to be attached to subordinate workspaces created by running the workspace this workspace creates - which means the gh template child mod terraform-template-lz-module/config/mod_workspaces.tf.

## project LZ workspace
## NOTE: new deployment of workspace will set to the latest TF version available because tf_version is not set so uses the default of >=1.9.0.
## NOTE: Updates to the management workspaces for LZs' TF version is handled by the api script; look in the api subdirectory of the a-org-platform repo.
#
resource "tfe_workspace" "main" {
  name              = "${var.prefix}-${var.hcpt_project}"
  organization      = var.hcpt_org
  auto_apply        = var.auto_apply
  terraform_version = var.tf_version    # need to specify explicitly
  project_id        = var.lz_project_id # gp lz workspaces together, their running will create app team project
  # workspace_tags      = var.workspace_tags
}

resource "tfe_workspace_settings" "main" {
  workspace_id        = tfe_workspace.main.id
  execution_mode      = var.execution_mode
  agent_pool_id       = var.agent_pool_id
  global_remote_state = true
}

## LZ repo
#
resource "github_repository" "main" {
  name                        = "${var.prefix}-${var.hcpt_project}"
  description                 = var.description
  visibility                  = var.visibility
  has_issues                  = var.has_issues
  has_projects                = var.has_projects
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  merge_commit_title          = "PR_TITLE"
  merge_commit_message        = "BLANK"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  delete_branch_on_merge      = true

  template {
    owner      = var.gh_template_owner
    repository = var.template_name
  }
}

resource "null_resource" "github-repo-self-edit" {
  depends_on = [github_repository.main]
  provisioner "local-exec" {
    command = <<-EOT
      sleep 10
      curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${var.gh_token}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${var.gh_template_owner}/${var.prefix}-${var.hcpt_project}/actions/workflows/global-replace.yml/dispatches -d '{"ref":"main","inputs":{}}'
    EOT
  }
}

## LZ workspace variable holding the TFC API token used to run TFE provider changes
#
resource "tfe_variable" "hcpt_token" {
  key          = "hcpt_token"
  value        = var.hcpt_token
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.main.id
  description  = "TFC API token used by the LZ workspace to deploy TFE provider changes"
}

## LZ workspace variable holding the GH API token used to create an IaC repository for the
## app team to back their workspaces as part of the LZ paradigm
#
resource "tfe_variable" "gh_token" {
  key          = "gh_token"
  value        = var.gh_token
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.main.id
  description  = "GH API token used by the LZ workspace to deploy GH repository for app teams"
}
