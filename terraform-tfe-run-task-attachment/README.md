# terraform-tfe-run-task-attachment
Terraform child module to manage attachment of a run task to a workspace.

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
| [tfe_workspace_run_task.main](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_run_task) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enforcement_level"></a> [enforcement\_level](#input\_enforcement\_level) | Enforcement level | `string` | n/a | yes |
| <a name="input_task_id"></a> [task\_id](#input\_task\_id) | Run task ID | `string` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Worksapce ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

