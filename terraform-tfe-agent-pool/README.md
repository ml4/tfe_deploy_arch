# terraform-tfe-agent-pool
Terraform child module to manage Terraform Cloud/Enterprise agent pool.
Remember that Terraform Cloud is an implementation of TFE.

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
| [tfe_agent_pool.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_pool) | resource |
| [tfe_agent_token.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_token) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the organization in which to create the agent pool | `string` | n/a | yes |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | Name of the agent pool to create | `string` | n/a | yes |
| <a name="input_tfe_agent_token_description"></a> [tfe\_agent\_token\_description](#input\_tfe\_agent\_token\_description) | Description to add to the creation of the token - helps UI consumption | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tap-tap-main-pool_id"></a> [tap-tap-main-pool\_id](#output\_tap-tap-main-pool\_id) | TF Agent Pool: Agent pool ID |
| <a name="output_tap-tap-main-pool_name"></a> [tap-tap-main-pool\_name](#output\_tap-tap-main-pool\_name) | TF Agent Pool: Agent pool name |
| <a name="output_tap-tat-main-id"></a> [tap-tat-main-id](#output\_tap-tat-main-id) | TF Agent Pool: TF Agent Token - Agent pool token id |
| <a name="output_tap-tat-main-token"></a> [tap-tat-main-token](#output\_tap-tat-main-token) | TF Agent Pool: TF Agent Token - Token material to provide this to the docker run or equivalent |
<!-- END_TF_DOCS -->
