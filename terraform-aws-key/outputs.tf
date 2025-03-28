## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
output "akp-akp-main-public_key" {
  value       = aws_key_pair.main.public_key
  description = "AWS Key Pair: AWS key pair public key content"
}

output "akp-akp-main-key_name" {
  value       = aws_key_pair.main.key_name
  description = "AWS Key Pair: AWS key pair public key name"
}
