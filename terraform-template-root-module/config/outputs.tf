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

## example:
# output "akp-akp-main-public_key" {
#   value       = aws_key_pair.main.public_key
#   description = "AWS Key Pair: AWS key pair public key content"
# }


