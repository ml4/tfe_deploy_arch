## project to hold all the app team's workspaces
#
module "app-team-iac-repo" {
  source         = "app.terraform.io/ml4/repository/github"
  version        = "1.0.15"
  name           = "c-team-%%PROJECT_NAME%%"
  description    = "IaC GitHub Repo for the app team"
  template_owner = "%%OWNER_NAME%%"
  template_name  = "terraform-template-root-module"
}
