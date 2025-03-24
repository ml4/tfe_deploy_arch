## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
output "toc-toc-main-id" {
  value       = tfe_oauth_client.main.id
  description = "TFE Oauth Client: TFE Oauth Client main ID"
}

output "toc-toc-main-oauth_token_id" {
  value       = tfe_oauth_client.main.oauth_token_id
  description = "TFE Oauth Client: TFE Oauth Client main Token ID"
}
