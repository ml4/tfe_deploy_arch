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
output "tort-tort-main-id" {
  value       = tfe_organization_run_task.main.id
  description = "TFE Organization Run Task: ID"
}


