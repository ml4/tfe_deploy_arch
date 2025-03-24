## acl.tf terraform configuration
## (c) 2019:12:06:ml4
## (c) 2020:10:02::anniversary:ml4
#

# ##    ####  #
##  #  #    # #
#    # #      #
###### #      #
#    # #    # #
#    #  ####  ######

#####  #    # #####  #      #  ####
#    # #    # #    # #      # #    #
#    # #    # #####  #      # #
#####  #    # #    # #      # #
#      #    # #    # #      # #    #
#       ####  #####  ###### #  ####

# ## NOTE THAT THIS RESOURCE AFFECTS THE PRIVATE SUBNETS AS TRAFFIC COMES THROUGH
# ## THE NAT GW IN THE PUBLIC SUBNET BEFORE LEAVING!
# #
# resource "aws_network_acl" "hcPubAcl" {
#   vpc_id = aws_vpc.hcVpc.id
#   subnet_ids = [
#     aws_subnet.hcPubSubnetA.id,
#   ]

#   ## IN - INCLUDING IN TO PUBLIC SUBNET FROM PRIVATE SUBNETS VIA NAT GW
#   ## SEE 10.0.0.0/16 ROUTING WHICH NEEDS TO BE ALLOWED IN HERE IN ORDER TO GET
#   ## OUT TO THE INTERNET
#   #
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 101
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 102
#     action     = "allow"
#     cidr_block = "10.0.0.0/16"
#     from_port  = 80
#     to_port    = 80
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 103
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 104
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }
#   ingress {
#     protocol   = "icmp"
#     rule_no    = 105
#     action     = "allow"
#     cidr_block = "10.0.0.0/16"
#     from_port  = -1
#     to_port    = -1
#     icmp_type  = -1
#     icmp_code  = -1
#   }

#   ## OUT
#   #
#   egress {
#     protocol   = "tcp"
#     rule_no    = 201
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }
#   egress {
#     protocol   = "tcp"
#     rule_no    = 202
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }
#   egress {
#     protocol   = "tcp"
#     rule_no    = 203
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }
#   egress {
#     protocol   = "tcp"
#     rule_no    = 204
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }
#   egress {
#     protocol   = "icmp"
#     rule_no    = 205
#     action     = "allow"
#     cidr_block = "10.0.0.0/16"
#     from_port  = -1
#     to_port    = -1
#     icmp_type  = -1
#     icmp_code  = -1
#   }
# }

# #####  #####  # #    #   ##   ##### ######
# #    # #    # # #    #  #  #    #   #
# #    # #    # # #    # #    #   #   #####
# #####  #####  # #    # ######   #   #
# #      #   #  #  #  #  #    #   #   #
# #      #    # #   ##   #    #   #   ######

# resource "aws_network_acl" "hcPrivAcl" {
#   vpc_id = aws_vpc.hcVpc.id
#   subnet_ids = [
#     aws_subnet.hcPrivSubnetA.id,
#     aws_subnet.hcPrivSubnetB.id,
#     aws_subnet.hcPrivSubnetC.id,
#   ]

#   ## IN
#   #
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 301
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 302
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }
#   ingress {
#     protocol   = "udp"
#     rule_no    = 303
#     action     = "allow"
#     cidr_block = "10.0.0.0/16"
#     from_port  = 1024
#     to_port    = 65535
#   }
#   ingress {
#     protocol   = "icmp"
#     rule_no    = 304
#     action     = "allow"
#     cidr_block = "10.0.0.0/16"
#     from_port  = -1
#     to_port    = -1
#     icmp_type  = -1
#     icmp_code  = -1
#   }

#   ## OUT - INCLUDING OTHER SUBNETS IN THE VPC!
#   #
#   egress {
#     protocol        = "tcp"
#     rule_no         = 401
#     action          = "allow"
#     cidr_block      = "0.0.0.0/0"
#     from_port       = 22
#     to_port         = 22
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
#   egress {
#     protocol        = "tcp"
#     rule_no         = 402
#     action          = "allow"
#     cidr_block      = "0.0.0.0/0"
#     from_port       = 80
#     to_port         = 80
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
#   egress {
#     protocol        = "tcp"
#     rule_no         = 403
#     action          = "allow"
#     cidr_block      = "0.0.0.0/0"
#     from_port       = 443
#     to_port         = 443
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
#   egress {
#     protocol        = "tcp"
#     rule_no         = 404
#     action          = "allow"
#     cidr_block      = "10.0.0.0/16"
#     from_port       = 1024
#     to_port         = 65535
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
#   egress {
#     protocol        = "udp"
#     rule_no         = 405
#     action          = "allow"
#     cidr_block      = "10.0.0.0/16"
#     from_port       = 1024
#     to_port         = 65535
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
#   egress {
#     protocol        = "icmp"
#     rule_no         = 406
#     action          = "allow"
#     cidr_block      = "10.0.0.0/16"
#     from_port       = -1
#     to_port         = -1
#     icmp_code       = null
#     icmp_type       = null
#     ipv6_cidr_block = null
#   }
# }

