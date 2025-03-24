# terraform-aws-key
Terraform module to manage AWS SSH keys.
Currently very simple - just the one key.

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
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key"></a> [key](#input\_key) | Public key used for accessing VMs in the VPC | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Currently, the prefix equals the whole key name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_akp-akp-main-key_name"></a> [akp-akp-main-key\_name](#output\_akp-akp-main-key\_name) | AWS Key Pair: AWS key pair public key name |
| <a name="output_akp-akp-main-public_key"></a> [akp-akp-main-public\_key](#output\_akp-akp-main-public\_key) | AWS Key Pair: AWS key pair public key content |
<!-- END_TF_DOCS -->
