## components stack definition
#

#  ####  # #####  #####   ####
# #    # # #    # #    # #
# #      # #    # #    #  ####
# #      # #    # #####       #
# #    # # #    # #   #  #    #
#  ####  # #####  #    #  ####

#################################################################################################################################################
## network services: set up CIDRs for use
#
component "lz_net_stack_cidrs" {
  for_each = var.regions
  version  = "1.0.0"
  source   = "hashicorp/subnets/cidr"

  inputs = {
    base_cidr_block = each.value[0]
    networks = [
      {
        name     = "${each.key}_pub1"
        new_bits = 3
      },
      {
        name     = "${each.key}_pub2"
        new_bits = 3
      },
      {
        name     = "${each.key}_pub3"
        new_bits = 3
      },
      {
        name     = "${each.key}_pri1"
        new_bits = 3
      },
      {
        name     = "${each.key}_pri2"
        new_bits = 3
      },
      {
        name     = "${each.key}_pri3"
        new_bits = 3
      }
    ]
  }
}

# #    # #####   ####      ####  #####  ######   ##   ##### #  ####  #    #
# #    # #    # #    #    #    # #    # #       #  #    #   # #    # ##   #
# #    # #    # #         #      #    # #####  #    #   #   # #    # # #  #
# #    # #####  #         #      #####  #      ######   #   # #    # #  # #
#  #  #  #      #    #    #    # #   #  #      #    #   #   # #    # #   ##
#   ##   #       ####      ####  #    # ###### #    #   #   #  ####  #    #

#################################################################################################################################################
## network services: VPC, subnets, route tables, security groups, etc.
#
component "lz_net_stack" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/vpc/aws"
  version = "1.0.80"

  inputs = {
    aws_region  = each.value[1]
    prefix      = var.common_tags["Owner"]
    common_tags = var.common_tags
    vpc_cidr    = each.value[0]
    public_subnet_cidrs = tolist([
      component.lz_net_stack_cidrs[each.key].networks[0].cidr_block,
      component.lz_net_stack_cidrs[each.key].networks[1].cidr_block,
      component.lz_net_stack_cidrs[each.key].networks[2].cidr_block
    ])
    private_subnet_cidrs = tolist([
      component.lz_net_stack_cidrs[each.key].networks[3].cidr_block,
      component.lz_net_stack_cidrs[each.key].networks[4].cidr_block,
      component.lz_net_stack_cidrs[each.key].networks[5].cidr_block
    ])
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source  = "app.terraform.io/ml4/vpc/aws"
#   version = "1.0.76"

#     for_each = var.regions
#     from = component.lz_net_stack
#     providers = {
#       aws     = provider.aws.this[each.key]
#     }
# }

# #####  ####  #    #     ####  #####  ######   ##   ##### #  ####  #    #
#   #   #    # #    #    #    # #    # #       #  #    #   # #    # ##   #
#   #   #      #    #    #      #    # #####  #    #   #   # #    # # #  #
#   #   #  ### # ## #    #      #####  #      ######   #   # #    # #  # #
#   #   #    # ##  ##    #    # #   #  #      #    #   #   # #    # #   ##
#   #    ####  #    #     ####  #    # ###### #    #   #   #  ####  #    #

#################################################################################################################################################
## Every region gets a transit gateway (tgw)
## We differentiate the primary and secondary as hubs and the rest as spokes using private subnets in each region
#
component "lz_net_transit_gateways" {
  for_each = var.regions
  source   = "app.terraform.io/ml4/transit-gateway/aws"
  version  = "1.0.14"

  inputs = {
    tgw = {
      name   = "${var.common_tags["Owner"]}-tgw-${var.regions.primary[1]}"
      region = each.value[1]
      role   = each.key == "primary" ? "primary" : each.key == "secondary" ? "secondary" : "spoke"
    }
    subnet_ids = [
      component.lz_net_stack[each.key].av-as-priv_subnets-id[0],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[1],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[2]
    ]
    vpc_id      = component.lz_net_stack[each.key].av-av-main-id
    common_tags = var.common_tags
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway/aws"
#   version = "1.0.14"

#   from = component.lz_net_transit_gateways
#   for_each = var.regions
#   providers = {
#     aws     = provider.aws.this[each.key]
#   }
# }

# #####  ####  #    #    #    # #    # #####       ##   ##### #####   ##    ####  #    #
#   #   #    # #    #    #    # #    # #    #     #  #    #     #    #  #  #    # #    #
#   #   #      #    #    ###### #    # #####     #    #   #     #   #    # #      ######
#   #   #  ### # ## #    #    # #    # #    #    ######   #     #   ###### #      #    #
#   #   #    # ##  ##    #    # #    # #    #    #    #   #     #   #    # #    # #    #
#   #    ####  #    #    #    #  ####  #####     #    #   #     #   #    #  ####  #    #

#################################################################################################################################################
## network services: transit gateway hub attachment - primary and secondary
## outputs: aws_ec2_transit_gateway_peering_attachment-id
#
component "lz_net_transit_gateway_hub_attachment_primary_and_secondary" {
  source  = "app.terraform.io/ml4/transit-gateway-attachment/aws"
  version = "1.0.6"

  inputs = {
    peer_region             = var.regions.secondary[1]
    transit_gateway_id      = component.lz_net_transit_gateways["primary"].tgw_transit_gateway_id
    peer_transit_gateway_id = component.lz_net_transit_gateways["secondary"].tgw_transit_gateway_id
    common_tags             = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-primary
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment/aws"
#   version = "1.0.6"

#   from = component.lz_net_transit_gateway_hub_attachment_primary_and_secondary
#   providers = {
#     aws     = provider.aws.hub-primary
#   }
# }

# #####  ####  #    #     ####  #####   ####  #    # ######      ##   ##### #####   ##    ####  #    #
#   #   #    # #    #    #      #    # #    # #   #  #          #  #    #     #    #  #  #    # #    #
#   #   #      #    #     ####  #    # #    # ####   #####     #    #   #     #   #    # #      ######
#   #   #  ### # ## #         # #####  #    # #  #   #         ######   #     #   ###### #      #    #
#   #   #    # ##  ##    #    # #      #    # #   #  #         #    #   #     #   #    # #    # #    #
#   #    ####  #    #     ####  #       ####  #    # ######    #    #   #     #   #    #  ####  #    #

#################################################################################################################################################
## network services: transit gateway spoke attachment to primary hub
## outputs: aws_ec2_transit_gateway_peering_attachment-id
#
component "lz_net_transit_gateway_spoke_attachment_to_primary" {
  for_each = var.spokes
  source   = "app.terraform.io/ml4/transit-gateway-attachment/aws"
  version  = "1.0.6"

  inputs = {
    peer_region             = var.regions.primary[1]
    transit_gateway_id      = component.lz_net_transit_gateways[each.key].tgw_transit_gateway_id
    peer_transit_gateway_id = component.lz_net_transit_gateways["primary"].tgw_transit_gateway_id
    common_tags             = var.common_tags
  }

  providers = {
    aws = provider.aws.spokes[each.key]
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment/aws"
#   version = "1.0.6"

#   from = component.lz_net_transit_gateway_spoke_attachment_to_primary
#   for_each = var.spokes
#   providers = {
#     aws     = provider.aws.spokes[each.key]
#   }
# }

#################################################################################################################################################
## network services: transit gateway spoke attachment to secondary hub
## outputs: aws_ec2_transit_gateway_peering_attachment-id
#
component "lz_net_transit_gateway_spoke_attachment_to_secondary" {
  for_each = var.spokes
  source   = "app.terraform.io/ml4/transit-gateway-attachment/aws"
  version  = "1.0.6"

  inputs = {
    peer_region             = var.regions.secondary[1]
    transit_gateway_id      = component.lz_net_transit_gateways[each.key].tgw_transit_gateway_id
    peer_transit_gateway_id = component.lz_net_transit_gateways["secondary"].tgw_transit_gateway_id
    common_tags             = var.common_tags
  }

  providers = {
    aws = provider.aws.spokes[each.key]
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment/aws"
#   version = "1.0.6"

#   from = component.lz_net_transit_gateway_spoke_attachment_to_secondary
#   for_each = var.spokes
#   providers = {
#     aws     = provider.aws.spokes[each.key]
#   }
# }

# #####  ####  #    #    #    # #    # #####       ##   ##### #####   ##    ####  #    #      ##    ####   ####  ###### #####  #####
#   #   #    # #    #    #    # #    # #    #     #  #    #     #    #  #  #    # #    #     #  #  #    # #    # #      #    #   #
#   #   #      #    #    ###### #    # #####     #    #   #     #   #    # #      ######    #    # #      #      #####  #    #   #
#   #   #  ### # ## #    #    # #    # #    #    ######   #     #   ###### #      #    #    ###### #      #      #      #####    #
#   #   #    # ##  ##    #    # #    # #    #    #    #   #     #   #    # #    # #    #    #    # #    # #    # #      #        #
#   #    ####  #    #    #    #  ####  #####     #    #   #     #   #    #  ####  #    #    #    #  ####   ####  ###### #        #

#################################################################################################################################################
## network services: transit gateway hub attachment acceptance - accept primary-secondary attach
## outputs: aws_ec2_transit_gateway_peering_attachment-id
#
component "lz_net_transit_gateway_hub_attachment_acceptance_primary_and_secondary" {
  source  = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
  version = "1.0.2"

  inputs = {
    transit_gateway_attachment_id = component.lz_net_transit_gateway_hub_attachment_primary_and_secondary.aws_ec2_transit_gateway_peering_attachment-id
    common_tags                   = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-secondary
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
#   version = "1.0.2"

#   from = component.lz_net_transit_gateway_hub_attachment_acceptance_primary_and_secondary
#   providers = {
#     aws     = provider.aws.hub-primary
#   }
# }

# #####  ####  #    #     ####  #####   ####  #    # ######      ##   ##### #####   ##    ####  #    #      ##    ####   ####  ###### #####  #####
#   #   #    # #    #    #      #    # #    # #   #  #          #  #    #     #    #  #  #    # #    #     #  #  #    # #    # #      #    #   #
#   #   #      #    #     ####  #    # #    # ####   #####     #    #   #     #   #    # #      ######    #    # #      #      #####  #    #   #
#   #   #  ### # ## #         # #####  #    # #  #   #         ######   #     #   ###### #      #    #    ###### #      #      #      #####    #
#   #   #    # ##  ##    #    # #      #    # #   #  #         #    #   #     #   #    # #    # #    #    #    # #    # #    # #      #        #
#   #    ####  #    #     ####  #       ####  #    # ######    #    #   #     #   #    #  ####  #    #    #    #  ####   ####  ###### #        #

#################################################################################################################################################
## network services: transit gateway spoke attachment acceptance - accept spoke attach to primary
#
component "lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_primary" {
  for_each = var.spokes
  source   = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
  version  = "1.0.2"

  inputs = {
    transit_gateway_attachment_id = component.lz_net_transit_gateway_spoke_attachment_to_primary[each.key].aws_ec2_transit_gateway_peering_attachment-id
    common_tags                   = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-primary
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
#   version = "1.0.2"

#   from = component.lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_primary
#   for_each = var.spokes
#   providers = {
#     aws     = provider.aws.spokes[each.key]
#   }
# }

#################################################################################################################################################
## network services: transit gateway spoke attachment acceptance - accept spoke attach to secondary
#
component "lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_secondary" {
  for_each = var.spokes
  source   = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
  version  = "1.0.2"

  inputs = {
    transit_gateway_attachment_id = component.lz_net_transit_gateway_spoke_attachment_to_secondary[each.key].aws_ec2_transit_gateway_peering_attachment-id
    common_tags                   = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-secondary
  }
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-attachment-acceptance/aws"
#   version = "1.0.2"

#   from = component.lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_secondary
#   for_each = var.spokes
#   providers = {
#     aws     = provider.aws.spokes[each.key]
#   }
# }

# #####  ####  #    #    #####   ####  #    # ##### # #    #  ####
#   #   #    # #    #    #    # #    # #    #   #   # ##   # #    #
#   #   #      #    #    #    # #    # #    #   #   # # #  # #
#   #   #  ### # ## #    #####  #    # #    #   #   # #  # # #  ###
#   #   #    # ##  ##    #   #  #    # #    #   #   # #   ## #    #
#   #    ####  #    #    #    #  ####   ####    #   # #    #  ####

#################################################################################################################################################
## network services: transit gateway routing - primary
#
component "lz_net_transit_gateway_routing_primary" {
  source  = "app.terraform.io/ml4/transit-gateway-routing/aws"
  version = "1.0.6"

  inputs = {
    routes_to = merge(
      {
        "${var.regions.secondary[0]}" = component.lz_net_transit_gateway_hub_attachment_primary_and_secondary.aws_ec2_transit_gateway_peering_attachment-id
      },
      {
        for spoke_key, spoke_value in var.spokes : spoke_value[0] => component.lz_net_transit_gateway_spoke_attachment_to_primary[spoke_key].aws_ec2_transit_gateway_peering_attachment-id
      }
    )
    gateway_rt_id = component.lz_net_transit_gateways["primary"].propagation_default_route_table_id
    common_tags   = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-primary
  }
  depends_on = [component.lz_net_transit_gateway_routing_spokes]
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-routing/aws"
#   version = "1.0.6"

#   from = component.lz_net_transit_gateway_routing_primary
#   providers = {
#     aws     = provider.aws.hub-primary
#   }
# }

#################################################################################################################################################
## network services: transit gateway routing - secondary
#
component "lz_net_transit_gateway_routing_secondary" {
  source  = "app.terraform.io/ml4/transit-gateway-routing/aws"
  version = "1.0.6"

  inputs = {
    routes_to = merge(
      {
        "${var.regions.primary[0]}" = component.lz_net_transit_gateway_hub_attachment_primary_and_secondary.aws_ec2_transit_gateway_peering_attachment-id
      },
      {
        for spoke_key, spoke_value in var.spokes : spoke_value[0] => component.lz_net_transit_gateway_spoke_attachment_to_secondary[spoke_key].aws_ec2_transit_gateway_peering_attachment-id
      }
    )
    gateway_rt_id = component.lz_net_transit_gateways["secondary"].propagation_default_route_table_id
    common_tags   = var.common_tags
  }

  providers = {
    aws = provider.aws.hub-secondary
  }
  depends_on = [component.lz_net_transit_gateway_routing_spokes]
}

# removed {
#   source  = "app.terraform.io/ml4/transit-gateway-routing/aws"
#   version = "1.0.6"

#   from = component.lz_net_transit_gateway_routing_secondary
#   providers = {
#     aws = provider.aws.hub-secondary
#   }
# }

#################################################################################################################################################
## network services: transit gateway routing - spokes
#
component "lz_net_transit_gateway_routing_spokes" {
  for_each = var.spokes
  source   = "app.terraform.io/ml4/transit-gateway-routing/aws"
  version  = "1.0.6"

  inputs = {
    routes_to = {
      "${var.regions.primary[0]}"   = component.lz_net_transit_gateway_spoke_attachment_to_primary[each.key].aws_ec2_transit_gateway_peering_attachment-id
      "${var.regions.secondary[0]}" = component.lz_net_transit_gateway_spoke_attachment_to_secondary[each.key].aws_ec2_transit_gateway_peering_attachment-id
    }
    gateway_rt_id = component.lz_net_transit_gateways[each.key].propagation_default_route_table_id
    common_tags   = var.common_tags
  }

  providers = {
    aws = provider.aws.spokes[each.key]
  }
  depends_on = [component.lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_primary]
}

# #    # #####   ####     #####   ####  #    # ##### # #    #  ####
# #    # #    # #    #    #    # #    # #    #   #   # ##   # #    #
# #    # #    # #         #    # #    # #    #   #   # # #  # #
# #    # #####  #         #####  #    # #    #   #   # #  # # #  ###
#  #  #  #      #    #    #   #  #    # #    #   #   # #   ## #    #
#   ##   #       ####     #    #  ####   ####    #   # #    #  ####

#################################################################################################################################################

## add VPC route table routes for each CIDR in the other 5 regions - all routes point to the local transit gateway
## network services: connect VPCs to their respective transit gateways - for each destination CIDR in the set
#
component "lz_net_vpc_to_local_tgw_routes" {
  for_each = var.regions
  source   = "app.terraform.io/ml4/routes/aws"
  version  = "1.0.2"

  inputs = {
    route_table_id          = component.lz_net_stack[each.key].av-art-private-id
    destination_cidr_blocks = [for region_name, region_data in var.regions : region_data[0] if region_name != each.key]
    transit_gateway_id      = component.lz_net_transit_gateways[each.key].tgw_transit_gateway_id
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
  depends_on = [component.lz_net_transit_gateway_hub_attachment_acceptance_spoke_to_primary] # for good measure
}


# removed {
#   source  = "app.terraform.io/ml4/routes/aws"
#   version = "1.0.2"

#   from     = component.lz_net_vpc_to_local_tgw_routes_primary
#   providers = {
#     aws = provider.aws.regions[each.key]
#   }
# }

#####  #####  # #    #   ##   ##### ######    #    #  ####   ####  ##### ###### #####     ######  ####  #    # ######
#    # #    # # #    #  #  #    #   #         #    # #    # #        #   #      #    #        #  #    # ##   # #
#    # #    # # #    # #    #   #   #####     ###### #    #  ####    #   #####  #    #       #   #    # # #  # #####
#####  #####  # #    # ######   #   #         #    # #    #      #   #   #      #    #      #    #    # #  # # #
#      #   #  #  #  #  #    #   #   #         #    # #    # #    #   #   #      #    #     #     #    # #   ## #
#      #    # #   ##   #    #   #   ######    #    #  ####   ####    #   ###### #####     ######  ####  #    # ######

#################################################################################################################################################

## add a private hosted zone, associated to the created VPCs in this stack
#
# component "lz_net_private_hosted_zones" {
#   for_each = var.regions
#   source   = "app.terraform.io/ml4/private-hosted-zone/aws"
#   version  = "1.0.2"

#   inputs = {
#     zone_name = var.domain
#     vpc_ids = [
#       component.lz_net_stack[each.key].av-av-main-id
#     ]
#   }

#   providers = {
#     aws = provider.aws.this[each.key]
#   }
# }

removed {
  source  = "app.terraform.io/ml4/private-hosted-zone/aws"
  version = "1.0.2"

  for_each = var.regions
  from     = component.lz_net_private_hosted_zones
  providers = {
    aws = provider.aws.this[each.key]
  }
}
