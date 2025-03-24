## project to hold all the landing zone workspaces
#
module "b-lz-project" {
  source  = "app.terraform.io/ml4/project/tfe"
  version = "0.0.7"
  org     = var.organization # tfc object context
  project = "b-lzs"
}
