## terraform-random-password
Deploy random string of specified length (default 8)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_string.random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_length"></a> [length](#input\_length) | The length of the password | `number` | `8` | no |
| <a name="input_lower"></a> [lower](#input\_lower) | Whether to include lowercase characters | `bool` | `true` | no |
| <a name="input_special"></a> [special](#input\_special) | Whether to include special characters | `bool` | `false` | no |
| <a name="input_upper"></a> [upper](#input\_upper) | Whether to include uppercase characters | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rs_rs_string_result"></a> [rs\_rs\_string\_result](#output\_rs\_rs\_string\_result) | Random string: Random string result |
<!-- END_TF_DOCS -->
