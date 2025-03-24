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
## AWS specific
#
## Primary AWS VPC
#
output "net-tav-primary_regional_network-av-av-main-id" {
  value       = module.aws-vpc-primary.av-av-main-id
  description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS VPC ID"
}

output "net-tav-primary_regional_network-av-ang-main-subnet_id" {
  value       = module.aws-vpc-primary.av-ang-main-subnet_id
  description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS VPC main subnet IDs"
}

output "net-tav-primary_regional_network-av-as-pub_subnets-id" {
  value       = module.aws-vpc-primary.av-as-pub_subnets-id
  description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS VPC public subnet IDs"
}

output "net-tav-primary_regional_network-av-as-priv_subnets-id" {
  value       = module.aws-vpc-primary.av-as-priv_subnets-id
  description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS VPC private subnet IDs"
}

output "net-tav-primary_regional_network-av-asg-def-id" {
  value       = module.aws-vpc-primary.av-asg-def-id
  description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS Security Group - default"
}

# ## Secondary AWS VPC
# #
# output "net-tav-secondary_regional_network-av-av-main-id" {
#   value       = module.aws-vpc-secondary.av-av-main-id
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC ID"
# }

# output "net-tav-secondary_regional_network-av-ang-main-subnet_id" {
#   value       = module.aws-vpc-secondary.av-ang-main-subnet_id
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC main subnet IDs"
# }

# output "net-tav-secondary_regional_network-av-as-pub_subnets-id" {
#   value       = module.aws-vpc-secondary.av-as-pub_subnets-id
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC public subnet IDs"
# }

# output "net-tav-secondary_regional_network-av-as-priv_subnets-id" {
#   value       = module.aws-vpc-secondary.av-as-priv_subnets-id
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC private subnet IDs"
# }

# output "net-tav-secondary_regional_network-av-asg-def-id" {
#   value       = module.aws-vpc-secondary.av-asg-def-id
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS Security Group - default"
# }

# ## Tertiary AWS VPC
# #
# output "net-tav-tertiary_regional_network-av-av-main-id" {
#   value       = module.aws-vpc-tertiary.av-av-main-id
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC ID"
# }

# output "net-tav-tertiary_regional_network-av-ang-main-subnet_id" {
#   value       = module.aws-vpc-tertiary.av-ang-main-subnet_id
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC main subnet IDs"
# }

# output "net-tav-tertiary_regional_network-av-as-pub_subnets-id" {
#   value       = module.aws-vpc-tertiary.av-as-pub_subnets-id
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC public subnet IDs"
# }

# output "net-tav-tertiary_regional_network-av-as-priv_subnets-id" {
#   value       = module.aws-vpc-tertiary.av-as-priv_subnets-id
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC private subnet IDs"
# }

# output "net-tav-tertiary_regional_network-av-asg-def-id" {
#   value       = module.aws-vpc-tertiary.av-asg-def-id
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS Security Group - default"
# }

# ## Additional HashiCorp work
# #
# output "net-tav-primary_regional_network-av-asg-tfe-id" {
#   value       = module.aws-vpc-primary.av-asg-tfe-id
#   description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS Security Group - TFE"
# }

# ## cidr table
# #
# # output "net-tav-primary_regional_network-av-av-main-tags-name" {
# #   value       = module.aws-vpc-primary.av-av-main-tags-name
# #   description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: Primary AWS VPC name tag"
# # }

# output "net-tav-primary_regional_network-av-as-pub_subnets-cidr_block" {
#   value       = module.aws-vpc-primary.av-as-pub_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: primary AWS VPC public subnet IDs"
# }

# output "net-tav-primary_regional_network-av-as-priv_subnets-cidr_block" {
#   value       = module.aws-vpc-primary.av-as-priv_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] primary regional network - AWS VPC: primary AWS VPC private subnet IDs"
# }


# # output "net-tav-secondary_regional_network-av-av-main-tags-name" {
# #   value       = module.aws-vpc-secondary.av-av-main-tags-name
# #   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC name tag"
# # }

# output "net-tav-secondary_regional_network-av-as-pub_subnets-cidr_block" {
#   value       = module.aws-vpc-secondary.av-as-pub_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC public subnet IDs"
# }

# output "net-tav-secondary_regional_network-av-as-priv_subnets-cidr_block" {
#   value       = module.aws-vpc-secondary.av-as-priv_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] secondary regional network - AWS VPC: secondary AWS VPC private subnet IDs"
# }


# # output "net-tav-tertiary_regional_network-av-av-main-tags-name" {
# #   value       = module.aws-vpc-tertiary.av-av-main-tags-name
# #   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC name tag"
# # }

# output "net-tav-tertiary_regional_network-av-as-pub_subnets-cidr_block" {
#   value       = module.aws-vpc-tertiary.av-as-pub_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC public subnet IDs"
# }

# output "net-tav-tertiary_regional_network-av-as-priv_subnets-cidr_block" {
#   value       = module.aws-vpc-tertiary.av-as-priv_subnets-cidr_block
#   description = "Network [terraform-aws-vpc] tertiary regional network - AWS VPC: tertiary AWS VPC private subnet IDs"
# }
