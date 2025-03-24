# terraform-aws-vpc
Terraform module which deploys a non-default AWS VPC with security gp set for hashistack

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.disused_def](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.cv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.def](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.v](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.s3_assoc_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3_assoc_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_vpc_endpoint_service.s3_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to (e.g. eu-west-1) | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | tags common to all taggable resources | `map(string)` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | main prefix in front of most infra for multi-user accounts | `string` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | (Optional) List of private subnet CIDR ranges to create in VPC. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | (Optional) List of public subnet CIDR ranges to create in VPC. | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for VPC | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_av-ang-main-subnet_id"></a> [av-ang-main-subnet\_id](#output\_av-ang-main-subnet\_id) | AWS VPC: VPC main subnet IDs |
| <a name="output_av-as-priv_subnets-id"></a> [av-as-priv\_subnets-id](#output\_av-as-priv\_subnets-id) | AWS VPC: VPC private subnet IDs |
| <a name="output_av-as-pub_subnets-id"></a> [av-as-pub\_subnets-id](#output\_av-as-pub\_subnets-id) | AWS VPC: VPC public subnet IDs |
| <a name="output_av-asg-c-id"></a> [av-asg-c-id](#output\_av-asg-c-id) | AWS VPC: Security Group - Consul |
| <a name="output_av-asg-cv-id"></a> [av-asg-cv-id](#output\_av-asg-cv-id) | AWS VPC: Security Group - Consul and Vault |
| <a name="output_av-asg-def-id"></a> [av-asg-def-id](#output\_av-asg-def-id) | AWS VPC: Security Group - default |
| <a name="output_av-asg-tfe-id"></a> [av-asg-tfe-id](#output\_av-asg-tfe-id) | AWS VPC: Security Group - TFE |
| <a name="output_av-asg-v-id"></a> [av-asg-v-id](#output\_av-asg-v-id) | AWS VPC: Security Group - Vault |
| <a name="output_av-av-main-id"></a> [av-av-main-id](#output\_av-av-main-id) | AWS VPC: VPC ID |
| <a name="output_av-av-main-tags-Name"></a> [av-av-main-tags-Name](#output\_av-av-main-tags-Name) | AWS VPC: VPC name tag |
<!-- END_TF_DOCS -->
