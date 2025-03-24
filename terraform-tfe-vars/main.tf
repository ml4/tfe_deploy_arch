resource "tfe_variable" "main" {
  key             = var.key
  value           = var.value
  category        = var.category
  workspace_id    = var.workspace_id != null ? var.workspace_id : null
  variable_set_id = var.variable_set_id != null ? var.variable_set_id : null
  description     = var.description
  sensitive       = var.sensitive
}
