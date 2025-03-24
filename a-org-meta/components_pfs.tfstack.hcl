#################################################################################################################################################
## platform services (devsecops): security (bastions)
## the mod is only data sources to provide information to the stacks cfg
## AWS secrets manager items: license, TLS cert/CA bundle.
#
component "lz_pfs_aws_data_sources" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/stacks-data-sources/aws"
  version = "1.0.30"

  inputs = {
    ## dev-vault-lab.aws.pi-ccn.org
    #
    vault_fqdn     = "${var.environment}-vault-${var.project}.${var.cloud}.${var.domain}"
    terraform_fqdn = "${var.environment}-tfe-${var.project}.${var.cloud}.${var.domain}"
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source   = "app.terraform.io/ml4/stacks-data-sources/aws"
#   version  = "1.0.30"
#   for_each = var.regions
#   from     = component.lz_pfs_aws_data_sources
#   providers = {
#     aws = provider.aws.this[each.key]
#   }
# }

#################################################################################################################################################
## HCP packer version and artefact for bastion AMI
#
component "lz_pfs_data_sources_bastion" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/stacks-data-sources/hcp"
  version = "1.0.6"

  inputs = {
    machine_type = "bastion"
    csp          = "aws"
    region       = each.value[1]
    channel      = "latest"
  }

  providers = {
    hcp = provider.hcp.this
  }
}

# removed {
#   source   = "app.terraform.io/ml4/stacks-data-sources/hcp"
#   version  = "1.0.6"
#   for_each = var.regions
#   from     = component.lz_pfs_data_sources_bastion
#   providers = {
#     hcp = provider.hcp.this
#   }
# }

#################################################################################################################################################
## Deploy bastions
#
component "lz_pfs_stack_bastion" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/bastion/aws"
  version = "1.0.47"

  inputs = {
    ami         = component.lz_pfs_data_sources_bastion[each.key].hcp_packer_artifact-external_identifier
    region      = each.value[1]
    subnet      = component.lz_net_stack[each.key].av-as-pub_subnets-id[0]
    volume_size = "70"
    key_name    = var.common_tags["Owner"]
    security_groups = [
      component.lz_net_stack[each.key].av-asg-def-id
    ]
    tags = merge(var.common_tags, { Name = "bastion" })
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source   = "app.terraform.io/ml4/bastion/aws"
#   version  = "1.0.47"
#   for_each = var.regions
#   from     = component.lz_pfs_stack_bastion
#   providers = {
#     aws = provider.aws.this[each.key]
#   }
# }

#################################################################################################################################################
## KMS to support Vault deployment in each region
#
component "lz_pfs_stack_kms" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/kms/aws"
  version = "1.0.21"

  inputs = {
    aws_region = each.value[1]
    alias_name = "alias/${var.common_tags["Owner"]}"
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source   = "app.terraform.io/ml4/kms/aws"
#   version  = "1.0.21"
#   for_each = var.regions
#   from     = component.lz_pfs_stack_kms
#   providers = {
#     aws = provider.aws.this[each.key]
#   }
# }

#################################################################################################################################################
## HCP packer version and artefact for vault AMI
#
component "lz_pfs_data_sources_vault" {
  for_each = var.regions

  source  = "app.terraform.io/ml4/stacks-data-sources/hcp"
  version = "1.0.6"

  inputs = {
    machine_type = "vault-enterprise"
    csp          = "aws"
    region       = each.value[1]
    channel      = "latest"
  }

  providers = {
    hcp = provider.hcp.this
  }
}

# removed {
#   source   = "app.terraform.io/ml4/stacks-data-sources/hcp"
#   version  = "1.0.6"
#   for_each = var.regions
#   from     = component.lz_pfs_data_sources_vault
#   providers = {
#     hcp = provider.hcp.this
#   }
# }

#################################################################################################################################################
## Vault deployment in each region
#
component "lz_pfs_stack_vault" {
  for_each = var.regions

  source = "app.terraform.io/ml4/vault-enterprise/aws"
  # source = "app.terraform.io/ml4/vault-enterprise-hvd/aws"
  version = "1.0.3"

  inputs = {
    aws_region = each.value[1]
    alias_name = "alias/${var.common_tags["Owner"]}"

    #------------------------------------------------------------------------------
    # Common
    #------------------------------------------------------------------------------
    friendly_name_prefix = "vault-ml4"
    vault_fqdn           = "${each.value[1]}.${var.environment}-vault-${var.project}.${var.cloud}.${var.domain}" # Must match TLS cert SAN entry

    #------------------------------------------------------------------------------
    # Networking
    #------------------------------------------------------------------------------
    net_vpc_id            = component.lz_net_stack[each.key].av-av-main-id
    load_balancing_scheme = "INTERNAL"

    net_vault_subnet_ids = [
      component.lz_net_stack[each.key].av-as-priv_subnets-id[0],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[1],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[2]
    ]

    net_lb_subnet_ids = [
      component.lz_net_stack[each.key].av-as-priv_subnets-id[0],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[1],
      component.lz_net_stack[each.key].av-as-priv_subnets-id[2]
    ]

    ## needed for cross-region replication
    #
    net_ingress_vault_cidr_blocks = ["10.0.0.0/8"]
    net_ingress_ssh_cidr_blocks   = ["10.0.0.0/8"]

    #------------------------------------------------------------------------------
    # AWS Secrets Manager installation secrets and AWS KMS unseal key
    #------------------------------------------------------------------------------
    sm_vault_license_arn      = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-vault_hclic
    sm_vault_tls_cert_arn     = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-vault_cert_arn
    sm_vault_tls_cert_key_arn = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-vault_key_arn
    sm_vault_tls_ca_bundle    = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-ca_pem
    vault_seal_awskms_key_arn = component.lz_pfs_stack_kms[each.key].akk-akk-main-arn

    #------------------------------------------------------------------------------
    # Compute
    #------------------------------------------------------------------------------
    vm_key_pair_name = "ml4"
    vm_image_id      = component.lz_pfs_data_sources_bastion[each.key].hcp_packer_artifact-external_identifier

    #------------------------------------------------------------------------------
    # ml4
    #------------------------------------------------------------------------------
    vault_enable_ui = true
    tags            = merge(var.common_tags, { Name = "vault" })
  }

  providers = {
    aws    = provider.aws.this[each.key]
    random = provider.random.this
  }
}

# removed {
#   source   = "app.terraform.io/ml4/vault-enterprise/aws"
#   version  = "1.0.3"
#   for_each = var.regions
#   from     = component.lz_pfs_stack_vault
#   providers = {
#     aws    = provider.aws.this[each.key]
#     random = provider.random.this
#   }
# }

#################################################################################################################################################
## Vault DNS
component "lz_pfs_stack_vault_dns" {
  for_each = var.regions
  source  = "app.terraform.io/ml4/vault-stacks-dns/aws"
  version = "1.0.1"

  inputs = {
    zone     = var.domain
    fqdn     = "${each.value[1]}.${var.environment}-vault-${var.project}.${var.cloud}.${var.domain}"
    dns_name = component.lz_pfs_stack_vault[each.key].vault_load_balancer_name
  }

  providers = {
    aws = provider.aws.this[each.key]
  }
}

# removed {
#   source   = "app.terraform.io/ml4/vault-stacks-dns/aws"
#   version  = "1.0.1"
#   for_each = var.regions
#   from     = component.lz_pfs_stack_vault_dns
#   providers = {
#     aws = provider.aws.this[each.key]
#   }
# }

#################################################################################################################################################
## TFE deployment in just eu-north-1 but using the HVD mod modified by @RichardRussell
#
component "lz_pfs_stack_tfe" {
  for_each = var.primary_region
  source  = "hashicorp/terraform-enterprise-hvd/aws"
  version = "0.2.0"

  inputs = {
    region = each.value[1]

    #------------------------------------------------------------------------------
    # Bootstrap
    #------------------------------------------------------------------------------
    tfe_license_secret_arn             = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-terraform_hclic
    tfe_encryption_password_secret_arn = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-tfe_enc_password
    tfe_tls_cert_secret_arn            = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-terraform_cert_arn
    tfe_tls_privkey_secret_arn         = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-terraform_key_arn
    tfe_tls_ca_bundle_secret_arn       = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-ca_pem_b64

    #------------------------------------------------------------------------------
    # TFE config settings
    #------------------------------------------------------------------------------
    friendly_name_prefix = "terraform-ml4"
    tfe_fqdn             = "${each.value[1]}.${var.environment}-tfe-${var.project}.${var.cloud}.${var.domain}" # Must match TLS cert SAN entry
    tfe_image_tag        = "v202502-1"

    #------------------------------------------------------------------------------
    # Networking
    #------------------------------------------------------------------------------
    vpc_id = component.lz_net_stack[each.key].av-av-main-id
    lb_subnet_ids = [
      component.lz_net_stack[each.key].av-as-pub_subnets-id[0],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[1],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[2]
    ] # private subnets
    lb_is_internal = false
    ec2_subnet_ids = [
      component.lz_net_stack[each.key].av-as-pub_subnets-id[0],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[1],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[2]
    ] # private subnets
    rds_subnet_ids = [
      component.lz_net_stack[each.key].av-as-pub_subnets-id[0],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[1],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[2]
    ] # private subnets

    redis_subnet_ids = [
      component.lz_net_stack[each.key].av-as-pub_subnets-id[0],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[1],
      component.lz_net_stack[each.key].av-as-pub_subnets-id[2]
    ] # private subnets

    cidr_allow_ingress_tfe_443 = ["0.0.0.0/0"] # CIDR ranges of TFE users/clients, VCS
    cidr_allow_ingress_ec2_ssh = ["0.0.0.0/0"]

    #------------------------------------------------------------------------------
    # DNS (optional)
    #------------------------------------------------------------------------------
    create_route53_tfe_dns_record      = true
    route53_tfe_hosted_zone_name       = "pi-ccn.org"
    route53_tfe_hosted_zone_is_private = false

    #------------------------------------------------------------------------------
    # Compute
    #------------------------------------------------------------------------------
    container_runtime  = "docker"
    ec2_os_distro      = "ubuntu"
    ec2_ssh_key_pair   = "ml4"
    asg_instance_count = 1

    #------------------------------------------------------------------------------
    # Database
    #------------------------------------------------------------------------------
    tfe_database_password_secret_arn = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-tfe_enc_password
    rds_skip_final_snapshot          = false

    #------------------------------------------------------------------------------
    # Redis
    #------------------------------------------------------------------------------
    tfe_redis_password_secret_arn = component.lz_pfs_aws_data_sources[each.key].aws_secretsmanager_secret-tfe_redis_password

    #------------------------------------------------------------------------------
    # Log forwarding (optional)
    #------------------------------------------------------------------------------
    tfe_log_forwarding_enabled = false
    # log_fwd_destination_type   = "<s3>"
    # s3_log_fwd_bucket_name     = "<tfe-logging-bucket-name>"
  }

  providers = {
    aws = provider.aws.hub-primary
  }
}

# removed {
#   source   = "hashicorp/terraform-enterprise-hvd/aws"
#   version  = "0.2.0"
#   for_each = var.primary_region
#   from     = component.lz_pfs_stack_tfe
#   providers = {
#     aws = provider.aws.hub-primary
#   }
# }
