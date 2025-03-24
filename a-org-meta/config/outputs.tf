## outputs.tf root module terraform configuration
## Nomenclature: <a>-<b>-<c>-<e>-<f>-<g>-<h>-<i>
## where
## a = 'What is the function of this cfg?'
## b = Abbreviated underlying/child module name
## c = Reasonably free text description in camelCase
## then the child module output name
## d = abbreviated linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
## pool: eu-north-1
#
output "tfx-ttap-agent_pool_eu_north_1_tap-tap-main-pool_id" {
  value       = module.agent-pool-eu-north-1.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-north-1: Agent pool ID"
}

output "tfx-ttap-agent_pool_eu_north_1_tap-tap-main-pool_name" {
  value       = module.agent-pool-eu-north-1.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-north-1: Agent pool name"
}

output "tfx-ttap-agent_pool_eu_north_1_tap-tat-main-id" {
  value       = module.agent-pool-eu-north-1.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-north-1: Agent pool token ID"
}

output "tfx-ttap-agent_pool_eu_north_1_tap-tat-main-token" {
  value       = module.agent-pool-eu-north-1.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-north-1: Agent token material: SENSITIVE"
  sensitive   = true
}

## pool: eu-central-1
#
output "tfx-ttap-agent_pool_eu_central_1_tap-tap-main-pool_id" {
  value       = module.agent-pool-eu-central-1.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-central-1: Agent pool ID"
}

output "tfx-ttap-agent_pool_eu_central_1_tap-tap-main-pool_name" {
  value       = module.agent-pool-eu-central-1.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-central-1: Agent pool name"
}

output "tfx-ttap-agent_pool_eu_central_1_tap-tat-main-id" {
  value       = module.agent-pool-eu-central-1.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-central-1: Agent pool token ID"
}

output "tfx-ttap-agent_pool_eu_central_1_tap-tat-main-token" {
  value       = module.agent-pool-eu-central-1.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for eu-central-1: Agent token material: SENSITIVE"
  sensitive   = true
}

## pool: us-west-2
#
output "tfx-ttap-agent_pool_us_west_2_tap-tap-main-pool_id" {
  value       = module.agent-pool-us-west-2.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for us-west-2: Agent pool ID"
}

output "tfx-ttap-agent_pool_us_west_2_tap-tap-main-pool_name" {
  value       = module.agent-pool-us-west-2.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for us-west-2: Agent pool name"
}

output "tfx-ttap-agent_pool_us_west_2_tap-tat-main-id" {
  value       = module.agent-pool-us-west-2.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for us-west-2: Agent pool token ID"
}

output "tfx-ttap-agent_pool_us_west_2_tap-tat-main-token" {
  value       = module.agent-pool-us-west-2.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for us-west-2: Agent token material: SENSITIVE"
  sensitive   = true
}

## pool: ca-central-1
#
output "tfx-ttap-agent_pool_ca_central_1_tap-tap-main-pool_id" {
  value       = module.agent-pool-ca-central-1.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ca-central-1: Agent pool ID"
}

output "tfx-ttap-agent_pool_ca_central_1_tap-tap-main-pool_name" {
  value       = module.agent-pool-ca-central-1.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ca-central-1: Agent pool name"
}

output "tfx-ttap-agent_pool_ca_central_1_tap-tat-main-id" {
  value       = module.agent-pool-ca-central-1.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ca-central-1: Agent pool token ID"
}

output "tfx-ttap-agent_pool_ca_central_1_tap-tat-main-token" {
  value       = module.agent-pool-ca-central-1.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ca-central-1: Agent token material: SENSITIVE"
  sensitive   = true
}

## pool: ap-southeast-2
#
output "tfx-ttap-agent_pool_ap_southeast_2_tap-tap-main-pool_id" {
  value       = module.agent-pool-ap-southeast-2.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-southeast-2: Agent pool ID"
}

output "tfx-ttap-agent_pool_ap_southeast_2_tap-tap-main-pool_name" {
  value       = module.agent-pool-ap-southeast-2.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-southeast-2: Agent pool name"
}

output "tfx-ttap-agent_pool_ap_southeast_2_tap-tat-main-id" {
  value       = module.agent-pool-ap-southeast-2.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-southeast-2: Agent pool token ID"
}

output "tfx-ttap-agent_pool_ap_southeast_2_tap-tat-main-token" {
  value       = module.agent-pool-ap-southeast-2.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-southeast-2: Agent token material: SENSITIVE"
  sensitive   = true
}

## pool: ap-northeast-1
#
output "tfx-ttap-agent_pool_ap_northeast_1_tap-tap-main-pool_id" {
  value       = module.agent-pool-ap-northeast-1.tap-tap-main-pool_id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-northeast-1: Agent pool ID"
}

output "tfx-ttap-agent_pool_ap_northeast_1_tap-tap-main-pool_name" {
  value       = module.agent-pool-ap-northeast-1.tap-tap-main-pool_name
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-northeast-1: Agent pool name"
}

output "tfx-ttap-agent_pool_ap_northeast_1_tap-tat-main-id" {
  value       = module.agent-pool-ap-northeast-1.tap-tat-main-id
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-northeast-1: Agent pool token ID"
}

output "tfx-ttap-agent_pool_ap_northeast_1_tap-tat-main-token" {
  value       = module.agent-pool-ap-northeast-1.tap-tat-main-token
  description = "Terraform Cloud/Enterprise [terraform-tfe-agent-pool] TFC agent pool for ap-northeast-1: Agent token material: SENSITIVE"
  sensitive   = true
}



## oidc outputs
#
output "oidc-tadpc-hcpt_oidc_id-tvs-dynamic_creds-id" {
  value       = module.dynamic-provider-credentials.tvs-tvs-dynamic_creds-id
  description = "Terraform AWS Dynamic Provider Creds - OIDC Terraform Variable Set - Dynamic Creds ID"
}

output "oidc-tadpc-hcpt_oidc_arn-air-arn" {
  value       = module.dynamic-provider-credentials.air-air-role-arn
  description = "Terraform AWS Dynamic Provider Creds - OIDC AWS IAM Role - ARN"
}

