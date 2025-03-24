## main.tf terraform configuration
#
resource "tfe_workspace_run_task" "main" {
  workspace_id      = var.workspace_id
  task_id           = var.task_id
  enforcement_level = var.enforcement_level
}
