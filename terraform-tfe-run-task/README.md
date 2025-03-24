# terraform-tfe-run-task
Terraform child module to manage Run task attachment.

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
| [tfe_organization_run_task.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/organization_run_task) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Run task description | `string` | n/a | yes |
| <a name="input_hmac"></a> [hmac](#input\_hmac) | Run task description | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Run task name | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization name | `string` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | Run task url | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tort-tort-main-id"></a> [tort-tort-main-id](#output\_tort-tort-main-id) | TFE Organization Run Task: ID |
<!-- END_TF_DOCS -->



