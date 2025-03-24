# terraform-tfe-lz
Terraform child module to manage the creation of a landing zone which comprises:
- A workspace which is used to deploy n others - but typically three app team workspaces, dev, int and prod
- The vars to allow such a deploy
- A github repo for a 12-factor approach to the above, i.e. one repo for the code for all of the dev/int/prod workspaces as we do not put dev config in a different place to int config, especially as it should be the same config.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [null_resource.github-repo-self-edit](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tfe_project.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_variable.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_pool_id"></a> [agent\_pool\_id](#input\_agent\_pool\_id) | The ID of an agent pool assigned to the workspace | `string` | `null` | no |
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | Set whether to auto or manual apply | `bool` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Repository for Terraform root module of landing zone | `string` | n/a | yes |
| <a name="input_execution_mode"></a> [execution\_mode](#input\_execution\_mode) | The type of execution (remote/local/agent) for this workspace | `string` | `"remote"` | no |
| <a name="input_gh_template_owner"></a> [gh\_template\_owner](#input\_gh\_template\_owner) | The owner of the repository template e.g. ml4 | `string` | n/a | yes |
| <a name="input_gh_token"></a> [gh\_token](#input\_gh\_token) | The passed github PAT used by the null\_resource to trigger the self-editing workflow on repo delivery | `string` | n/a | yes |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Specify whether or not this repository has issues | `string` | `false` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Specify whether or not this repository has projects | `string` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Name prefix prepended to name of LZ GH repository and LZ TFC project created | `string` | n/a | yes |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Set terraform core version to run in the workspace | `string` | n/a | yes |
| <a name="input_tfc_org"></a> [tfc\_org](#input\_tfc\_org) | Organisation to put the project in | `string` | n/a | yes |
| <a name="input_tfc_project"></a> [tfc\_project](#input\_tfc\_project) | TFC project to create | `string` | n/a | yes |
| <a name="input_tfc_token"></a> [tfc\_token](#input\_tfc\_token) | TFC API token issued to the LZ workspace so it can deploy app-level TFC config like more workspaces | `string` | n/a | yes |
| <a name="input_variable_set_id_dynamic_creds"></a> [variable\_set\_id\_dynamic\_creds](#input\_variable\_set\_id\_dynamic\_creds) | A dynamic credentials variable set to attach to the workspace | `string` | `null` | no |
| <a name="input_variable_set_id_hcp_packer_machine_images"></a> [variable\_set\_id\_hcp\_packer\_machine\_images](#input\_variable\_set\_id\_hcp\_packer\_machine\_images) | A hcp packer variable set to attach to the workspace | `string` | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | visibility of requested repository | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tp-tp-main-id"></a> [tp-tp-main-id](#output\_tp-tp-main-id) | TFE provider project main ID |
| <a name="output_tw-tw-main-id"></a> [tw-tw-main-id](#output\_tw-tw-main-id) | TFE provider workspace main ID |
<!-- END_TF_DOCS -->

