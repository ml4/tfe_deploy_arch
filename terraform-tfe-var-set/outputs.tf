## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#

output "tvs-tvs-main-id" {
  value       = tfe_variable_set.main.id
  description = "TFE Variable Set: TFE Variable Set ID"
}
