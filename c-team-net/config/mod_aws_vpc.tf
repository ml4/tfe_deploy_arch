## VPCs
## inter-region VPC peering connection is the eventual aim here
#
## CIDR splitz SEE HERE FOR INFORMATION:
## https://github.com/hashicorp/terraform-cidr-subnets/tree/master
## https://registry.terraform.io/modules/hashicorp/subnets/cidr/1.0.0
#
module "primary_cidrs" {
  source          = "app.terraform.io/ml4/subnets/cidr"
  version         = "1.0.0"
  base_cidr_block = "10.0.0.0/16"
  networks = [
    { name = "primary_pub1", new_bits = 3 },
    { name = "primary_pub2", new_bits = 3 },
    { name = "primary_pub3", new_bits = 3 },
    { name = "primary_pri1", new_bits = 3 },
    { name = "primary_pri2", new_bits = 3 },
    { name = "primary_pri3", new_bits = 3 }
  ]
}

# module "secondary_cidrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.1.0.0/16"
#   networks = [
#     { name = "secondary_pub1", new_bits = 2 },
#     { name = "secondary_pub2", new_bits = 2 },
#     { name = "secondary_pub3", new_bits = 2 },
#     { name = "secondary_pri1", new_bits = 2 },
#     { name = "secondary_pri2", new_bits = 2 },
#     { name = "secondary_pri3", new_bits = 2 }
#   ]
# }

# module "tertiary_cidrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.2.0.0/16"
#   networks = [
#     { name = "tertiary_pub1", new_bits = 2 },
#     { name = "tertiary_pub2", new_bits = 2 },
#     { name = "tertiary_pub3", new_bits = 2 },
#     { name = "tertiary_pri1", new_bits = 2 },
#     { name = "tertiary_pri2", new_bits = 2 },
#     { name = "tertiary_pri3", new_bits = 2 }
#   ]
# }

# module "quaternary_cidrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.3.0.0/16"
#   networks = [
#     { name = "quaternary_pub1", new_bits = 2 },
#     { name = "quaternary_pub2", new_bits = 2 },
#     { name = "quaternary_pub3", new_bits = 2 },
#     { name = "quaternary_pri1", new_bits = 2 },
#     { name = "quaternary_pri2", new_bits = 2 },
#     { name = "quaternary_pri3", new_bits = 2 }
#   ]
# }

# module "quinary_cidrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.4.0.0/16"
#   networks = [
#     { name = "quinary_pub1", new_bits = 2 },
#     { name = "quinary_pub2", new_bits = 2 },
#     { name = "quinary_pub3", new_bits = 2 },
#     { name = "quinary_pri1", new_bits = 2 },
#     { name = "quinary_pri2", new_bits = 2 },
#     { name = "quinary_pri3", new_bits = 2 }
#   ]
# }

# module "senary_cidrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.5.0.0/16"
#   networks = [
#     { name = "senary_pub1", new_bits = 2 },
#     { name = "senary_pub2", new_bits = 2 },
#     { name = "senary_pub3", new_bits = 2 },
#     { name = "senary_pri1", new_bits = 2 },
#     { name = "senary_pri2", new_bits = 2 },
#     { name = "senary_pri3", new_bits = 2 }
#   ]
# }

module "aws-vpc-primary" {
  source      = "app.terraform.io/ml4/vpc/aws"
  version     = "1.0.80"
  aws_region  = var.primary_region
  prefix      = var.prefix
  vpc_cidr    = module.primary_cidrs.base_cidr_block
  common_tags = var.common_tags
  public_subnet_cidrs = tolist([
    module.primary_cidrs.networks[0].cidr_block,
    module.primary_cidrs.networks[1].cidr_block,
    module.primary_cidrs.networks[2].cidr_block
  ])
  private_subnet_cidrs = tolist([
    module.primary_cidrs.networks[3].cidr_block,
    module.primary_cidrs.networks[4].cidr_block,
    module.primary_cidrs.networks[5].cidr_block
  ])
}

# module "aws-vpc-secondary" {
#   providers   = { aws = aws.secondary }
#   source      = "app.terraform.io/ml4/vpc/aws"
#   version     = "1.0.71"
#   aws_region  = var.secondary_region
#   prefix      = var.prefix
#   vpc_cidr    = module.secondary_cidrs.base_cidr_block
#   common_tags = var.common_tags
#   public_subnet_cidrs = tolist([
#     module.secondary_cidrs.networks[0].cidr_block,
#     module.secondary_cidrs.networks[1].cidr_block,
#     module.secondary_cidrs.networks[2].cidr_block
#   ])
#   private_subnet_cidrs = tolist([
#     module.secondary_cidrs.networks[3].cidr_block,
#     module.secondary_cidrs.networks[4].cidr_block,
#     module.secondary_cidrs.networks[5].cidr_block
#   ])
# }

# module "aws-vpc-tertiary" {
#   providers   = { aws = aws.tertiary }
#   source      = "app.terraform.io/ml4/vpc/aws"
#   version     = "1.0.71"
#   aws_region  = var.tertiary_region
#   prefix      = var.prefix
#   vpc_cidr    = module.tertiary_cidrs.base_cidr_block
#   common_tags = var.common_tags
#   public_subnet_cidrs = tolist([
#     module.tertiary_cidrs.networks[0].cidr_block,
#     module.tertiary_cidrs.networks[1].cidr_block,
#     module.tertiary_cidrs.networks[2].cidr_block
#   ])
#   private_subnet_cidrs = tolist([
#     module.tertiary_cidrs.networks[3].cidr_block,
#     module.tertiary_cidrs.networks[4].cidr_block,
#     module.tertiary_cidrs.networks[5].cidr_block
#   ])
# }

# module "aws-vpc-quaternary" {
#   providers   = { aws = aws.quaternary }
#   source      = "app.terraform.io/ml4/vpc/aws"
#   version     = "1.0.71"
#   aws_region  = var.quaternary_region
#   prefix      = var.prefix
#   vpc_cidr    = module.quaternary_cidrs.base_cidr_block
#   common_tags = var.common_tags
#   public_subnet_cidrs = tolist([
#     module.quaternary_cidrs.networks[0].cidr_block,
#     module.quaternary_cidrs.networks[1].cidr_block,
#     module.quaternary_cidrs.networks[2].cidr_block
#   ])
#   private_subnet_cidrs = tolist([
#     module.quaternary_cidrs.networks[3].cidr_block,
#     module.quaternary_cidrs.networks[4].cidr_block,
#     module.quaternary_cidrs.networks[5].cidr_block
#   ])
# }

# module "aws-vpc-quinary" {
#   providers   = { aws = aws.quinary }
#   source      = "app.terraform.io/ml4/vpc/aws"
#   version     = "1.0.71"
#   aws_region  = var.quinary_region
#   prefix      = var.prefix
#   vpc_cidr    = module.quinary_cidrs.base_cidr_block
#   common_tags = var.common_tags
#   public_subnet_cidrs = tolist([
#     module.quinary_cidrs.networks[0].cidr_block,
#     module.quinary_cidrs.networks[1].cidr_block,
#     module.quinary_cidrs.networks[2].cidr_block
#   ])
#   private_subnet_cidrs = tolist([
#     module.quinary_cidrs.networks[3].cidr_block,
#     module.quinary_cidrs.networks[4].cidr_block,
#     module.quinary_cidrs.networks[5].cidr_block
#   ])
# }

# module "aws-vpc-senary" {
#   providers   = { aws = aws.senary }
#   source      = "app.terraform.io/ml4/vpc/aws"
#   version     = "1.0.71"
#   aws_region  = var.senary_region
#   prefix      = var.prefix
#   vpc_cidr    = module.senary_cidrs.base_cidr_block
#   common_tags = var.common_tags
#   public_subnet_cidrs = tolist([
#     module.senary_cidrs.networks[0].cidr_block,
#     module.senary_cidrs.networks[1].cidr_block,
#     module.senary_cidrs.networks[2].cidr_block
#   ])
#   private_subnet_cidrs = tolist([
#     module.senary_cidrs.networks[3].cidr_block,
#     module.senary_cidrs.networks[4].cidr_block,
#     module.senary_cidrs.networks[5].cidr_block
#   ])
# }
