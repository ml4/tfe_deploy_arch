## used by config/variables.tf:#   # google_credentials_var  = [for v in data.tfe_variables.all_variables.env : v if v.name == "GOOGLE_CREDENTIALS"]

# data "tfe_workspace" "top_level" {
#   name         = var.common_tags["Name"]
#   organization = var.organization
# }

# data "tfe_variables" "all_variables" {
#   workspace_id = data.tfe_workspace.top_level.id
# }

