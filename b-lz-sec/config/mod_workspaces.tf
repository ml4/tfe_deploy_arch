## main.tf for use with a passed json config and iteration
#
module "workspaces" {
  source         = "app.terraform.io/ml4/workspaces/tfe"
  version        = "1.0.55"
  for_each       = toset(var.workspaces)
  workspace_name = each.key
  org            = var.organization
  auto_apply     = true
  # terraform_version = var.tf_version  # always take the latest version and this will be updated by API later
  execution_mode = "remote"
  project_id     = module.app-team-project.tp-tp-main-id
  variable_sets  = ["hvs_vlt_cli_tfvars"]
}
