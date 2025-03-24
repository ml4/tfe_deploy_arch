# repoName
Terraform child module to manage TFE/C variable sets.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable_set.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description | `string` | `""` | no |
| <a name="input_global"></a> [global](#input\_global) | Whether or not set name is globally applied | `string` | `false` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Organisation name | `string` | n/a | yes |
| <a name="input_set_name"></a> [set\_name](#input\_set\_name) | Variable set name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tvs-tvs-main-id"></a> [tvs-tvs-main-id](#output\_tvs-tvs-main-id) | TFE Variable Set: TFE Variable Set ID |
<!-- END_TF_DOCS -->
