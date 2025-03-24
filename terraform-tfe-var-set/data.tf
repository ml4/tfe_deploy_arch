## data sources
#
data "tfe_project" "main" {
  name         = var.project_name
  organization = var.organization
}
