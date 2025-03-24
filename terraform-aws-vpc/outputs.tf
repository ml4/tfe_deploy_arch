## outputs.tf child module terraform configuration
## Nomenclature: <d>-<e>-<f>-<g>[-<h>]
## where
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
output "av-av-main-id" {
  value       = aws_vpc.main.id
  description = "AWS VPC: VPC ID"
}

## might interfere with the default aws provider tags now
##
## This map does not have an element with the key "Name".
##
#
#output "av-av-main-tags-name" {
#  value       = aws_vpc.main.tags.Name
#  description = "AWS VPC: VPC name tag"
#}

## ang
#
output "av-ang-main-subnet_id" {
  value       = aws_nat_gateway.main[*].subnet_id
  description = "AWS VPC: VPC main subnet IDs"
}

## Aws Subnet
#
output "av-as-pub_subnets-id" {
  value       = aws_subnet.public[*].id
  description = "AWS VPC: VPC public subnet IDs"
}

output "av-as-priv_subnets-id" {
  value       = aws_subnet.private[*].id
  description = "AWS VPC: VPC private subnet IDs"
}

output "av-as-pub_subnets-cidr_block" {
  value       = aws_subnet.public[*].cidr_block
  description = "AWS VPC: VPC public subnet CIDRs"
}

output "av-as-priv_subnets-cidr_block" {
  value       = aws_subnet.private[*].cidr_block
  description = "AWS VPC: VPC private subnet CIDRs"
}

## SG
#
output "av-asg-def-id" {
  value       = aws_security_group.def.id
  description = "AWS VPC: Security Group - default"
}

output "av-asg-tfe-id" {
  value       = aws_security_group.tfe.id
  description = "AWS VPC: Security Group - tfe"
}

## main VPC route table ids
#
output "av-art-private-id" {
  value       = aws_route_table.private.id
  description = "AWS VPC: VPC main route table ID"
}

output "av-art-public-id" {
  value       = aws_route_table.public.id
  description = "AWS VPC: VPC main route table ID"
}
