## agent pool set up
#

module "agent-pool-eu-north-1" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-eu-north-1"
  tfe_agent_token_description = "pool-eu-north-1-token"
}

module "agent-pool-eu-central-1" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-eu-central-1"
  tfe_agent_token_description = "pool-eu-central-1-token"
}

module "agent-pool-us-west-2" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-us-west-2"
  tfe_agent_token_description = "pool-us-west-2-token"
}

module "agent-pool-ca-central-1" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-ca-central-1"
  tfe_agent_token_description = "pool-ca-central-1-token"
}

module "agent-pool-ap-southeast-2" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-ap-southeast-2"
  tfe_agent_token_description = "pool-ap-southeast-2-token"
}

module "agent-pool-ap-northeast-1" {
  source                      = "app.terraform.io/ml4/agent-pool/tfe"
  version                     = "1.0.12"
  organization                = "ml4"
  pool_name                   = "pool-ap-northeast-1"
  tfe_agent_token_description = "pool-ap-northeast-1-token"
}

## In here: mod calls for agent machine deployments (July 2025 when stacks goes GA).