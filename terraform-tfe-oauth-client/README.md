# terraform-tfe-oauth-client
Module to deploy oauth into TFE

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
| [tfe_oauth_client.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oauthToken"></a> [oauthToken](#input\_oauthToken) | OAuth Token content | `string` | n/a | yes |
| <a name="input_tfxOrganization"></a> [tfxOrganization](#input\_tfxOrganization) | TFC/E Organisation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_toc-toc-main-id"></a> [toc-toc-main-id](#output\_toc-toc-main-id) | TFE Oauth Client: TFE Oauth Client main ID |
| <a name="output_toc-toc-main-oauth_token_id"></a> [toc-toc-main-oauth\_token\_id](#output\_toc-toc-main-oauth\_token\_id) | TFE Oauth Client: TFE Oauth Client main Token ID |
<!-- END_TF_DOCS -->
