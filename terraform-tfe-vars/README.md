# terraform-tfe-vars
Terraform workspace variables module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.2 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_category"></a> [category](#input\_category) | Workspace variable category | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description | `string` | `""` | no |
| <a name="input_key"></a> [key](#input\_key) | Workspace variable key | `string` | n/a | yes |
| <a name="input_sensitive"></a> [sensitive](#input\_sensitive) | Workspace variable sensitivity | `string` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | Workspace variable value | `string` | n/a | yes |
| <a name="input_variable_set_id"></a> [variable\_set\_id](#input\_variable\_set\_id) | Variable set ID | `string` | `null` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Workspace ID | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
