## main.tf terraform configuration
#
resource "tfe_registry_module" "main" {
  vcs_repo {
    display_identifier = "${var.org}/${var.repository}"
    identifier         = "${var.org}/${var.repository}"
    oauth_token_id     = var.oauth_token
  }
}
