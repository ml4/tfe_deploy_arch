## main.tf terraform configuration
#
resource "tfe_variable_set" "main" {
  name         = var.set_name
  global       = var.global
  organization = var.organization
  description  = var.description
}

resource "tfe_project_variable_set" "main" {
  count           = var.project_name == null ? 0 : 1
  variable_set_id = tfe_variable_set.main.id
  project_id      = data.tfe_project.main.id
}
