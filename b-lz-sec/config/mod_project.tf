## project to hold all the app team's workspaces
#
module "app-team-project" {
  source  = "app.terraform.io/ml4/project/tfe"
  version = "0.0.7"
  org     = var.organization # hcpt object context
  project = "c-team-sec"
}
