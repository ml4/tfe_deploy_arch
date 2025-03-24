## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
## example:
# output "akp-akp-main-public_key" {
#   value       = aws_key_pair.main.public_key
#   description = "AWS Key Pair: AWS key pair public key content"
# }

output "tap-tap-main-pool_id" {
  value       = tfe_agent_pool.main.id
  description = "TF Agent Pool: Agent pool ID"
}

output "tap-tap-main-pool_name" {
  value       = tfe_agent_pool.main.name
  description = "TF Agent Pool: Agent pool name"
}

output "tap-tat-main-id" {
  value       = tfe_agent_token.main.id
  description = "TF Agent Pool: TF Agent Token - Agent pool token id"
}

output "tap-tat-main-token" {
  value       = tfe_agent_token.main.token
  description = "TF Agent Pool: TF Agent Token - Token material to provide this to the docker run or equivalent"
}
