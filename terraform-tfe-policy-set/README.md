# terraform-tfe-policy-set
Module to deploy sentinel policies into TFE

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_policy_set.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/policy_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global"></a> [global](#input\_global) | TFE global | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | TFE OAuth token ID | `string` | n/a | yes |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | TFE policy description | `string` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | TFE policy name | `string` | n/a | yes |
| <a name="input_policy_organization"></a> [policy\_organization](#input\_policy\_organization) | TFE policy organization | `string` | n/a | yes |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | TFE policy path | `string` | n/a | yes |
| <a name="input_policy_repository"></a> [policy\_repository](#input\_policy\_repository) | TFE policy repository | `string` | n/a | yes |
| <a name="input_policy_repository_branch"></a> [policy\_repository\_branch](#input\_policy\_repository\_branch) | TFE policy repository branch | `string` | n/a | yes |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | TFE workspace IDs | `list(any)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
