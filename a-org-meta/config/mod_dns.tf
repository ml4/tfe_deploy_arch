## main dns setup - add pi-ccn.org hosted zone
#

## 2025:03:15::need to try private zones which need VPCs which means moving this to the stacks deploy.
#
module "dns" {
  source      = "app.terraform.io/ml4/dns/aws"
  version     = "1.0.19"
  hosted_zone = var.hosted_zone
}

#    #  ####  ##### ######      ##   ######     ####   ####  #####     ######  ####   ####  #####    ##   #####
##   # #    #   #   #          #  #      #     #    # #    # #    #    #      #    # #    # #    #  #  #  #    #
# #  # #    #   #   #####     #    #    #      #      #      #    #    #####  #    # #    # #####  #    # #    #
#  # # #    #   #   #         ######   #       #  ### #      #####     #      #    # #    # #    # ###### #####
#   ## #    #   #   #         #    #  #        #    # #    # #         #      #    # #    # #    # #    # #   #
#    #  ####    #   ######    #    # ######     ####   ####  #         #       ####   ####  #####  #    # #    #

#  switch on gcp and watch as it thinks the zone is already there which it is, so why

# module "dns-subdomain-delegation" {
#   source                = "app.terraform.io/ml4/dns-multicloud/aws"
#   version               = "1.0.6"
#   hosted_zone           = var.hosted_zone
#   owner                 = var.common_tags["Owner"]
#   create_aws_dns_zone   = true
#   create_azure_dns_zone = false
#   azure_location        = var.azure_location
#   create_gcp_dns_zone   = false
#   gcp_project           = local.project_id

#   depends_on = [module.dns]
# }
