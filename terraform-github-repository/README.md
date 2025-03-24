# terraform-github-repository
Terraform configuration to create a github repository

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_secret.main](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_secret) | resource |
| [github_repository.main](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of requested repository | `string` | n/a | yes |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Specify whether or not this repository has issues | `string` | `false` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Specify whether or not this repository has projects | `string` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of requested repository | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | KV map of repository secrets, mostly for things like GitHub Actions | `map(any)` | `{}` | no |
| <a name="input_template_owner"></a> [template\_owner](#input\_template\_owner) | The owner of the repository template | `string` | n/a | yes |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | visibility of requested repository | `string` | `"private"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
