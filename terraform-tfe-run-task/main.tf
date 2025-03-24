## main.tf terraform configuration
#
resource "tfe_organization_run_task" "main" {
  organization = var.organization
  url          = var.url
  name         = var.name
  enabled      = true
  description  = var.description
  hmac_key     = var.hmac
}