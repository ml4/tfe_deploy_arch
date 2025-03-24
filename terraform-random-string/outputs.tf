## outputs.tf child module terraform configuration
## Nomenclature: <d>_<e>_<f>_<g>[_<h>]
## where
## d = abbreviated linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
output "rs_rs_string_result" {
  value       = random_string.random_string.result
  description = "Random string: Random string result"
}
