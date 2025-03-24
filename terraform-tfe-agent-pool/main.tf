## agent pool set up
#
resource "tfe_agent_pool" "main" {
  name         = var.pool_name
  organization = var.organization
}

resource "tfe_agent_token" "main" {
  agent_pool_id = tfe_agent_pool.main.id
  description   = var.tfe_agent_token_description
}

