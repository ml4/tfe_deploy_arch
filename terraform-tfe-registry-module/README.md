# terraform-tfe-registry-module
Terraform child module to manage child modules in the PMR.

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
| [tfe_registry_module.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/registry_module) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oauth_token"></a> [oauth\_token](#input\_oauth\_token) | OAuth token required for ingress | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | Organisation name | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Main connected repository name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
