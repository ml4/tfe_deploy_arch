## stack outputs
#
# output "stack_data" {
#   type = list(object({
#     region = string
#     cidr   = string
#     vpc    = string
#     networks = list(object({
#       subnet     = string
#       cidr_block = string
#     }))
#     vault_cert_arn = string
#     vault_key_arn  = string
#     vault_lb       = string
#   }))
#   description = "Region-based network information"
#   value = [
#     for k in ["primary", "secondary", "tertiary", "quaternary", "quinary", "senary"] : {
#       region = var.regions[k][1]
#       cidr   = component.lz_net_stack_cidrs[k].base_cidr_block
#       vpc    = component.lz_net_stack[k].av-av-main-id
#       networks = [
#         for n in component.lz_net_stack_cidrs[k].networks : {
#           subnet     = n.name
#           cidr_block = n.cidr_block
#         }
#       ]
#       vault_cert_arn = component.lz_pfs_aws_data_sources[k].aws_secretsmanager_secret-vault_cert_arn
#       vault_key_arn  = component.lz_pfs_aws_data_sources[k].aws_secretsmanager_secret-vault_key_arn
#       vault_lb       = component.lz_pfs_stack_vault[k].vault_load_balancer_name
#     }
#   ]
# }


# type = map(string)
# description = "Base CIDR blocks"
# value = { for k in [ "primary", "secondary", "tertiary", "quaternary", "quinary", "senary" ] :
#   var.regions[k][1] => component.lz_net_stack_cidrs[k].base_cidr_block }
#   # broken # for k, v in var.regions : k => [ v[1], component.lz_net_stack_cidrs[v[1]].base_cidr_block ]
#   # working baseline need map(string) # for k, v in var.regions : k => v[1]
#   # working # [for block in component.lz_net_stack_cidrs : block.base_cidr_block]
