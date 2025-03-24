## project
#
variable "hcpt_org" {
  type        = string
  description = "Organisation to put the project in"
  default     = "ml4"
}

variable "hcpt_project" {
  type        = string
  description = "TFC project to create"
}

variable "lz_project_id" {
  type        = string
  description = "ID of TFC project to store/mgmt lz workspace"
}

## project LZ workspaces
#
variable "auto_apply" {
  type        = bool
  description = "Set whether to auto or manual apply"
  default     = true
}

variable "tf_version" {
  type        = string
  description = "Set terraform core version to run into the _mgmt_ workspace"
}

variable "execution_mode" {
  type        = string
  description = "The type of execution (remote/local/agent) for this workspace"
  default     = "remote"
}

variable "agent_pool_id" {
  type        = string
  description = "The ID of an agent pool assigned to the workspace"
  default     = null
}

variable "variable_set_id_dynamic_creds" {
  type        = string
  description = "A dynamic credentials variable set to attach to the workspace"
  default     = null
}

variable "variable_set_id_hcp_packer_machine_images" {
  type        = string
  description = "A hcp packer variable set to attach to the workspace"
  default     = null
}

# ## for hcpp checking run task
# #
# variable "task_id" {
#   type        = string
#   description = "Run task ID"
#   default     = null
# }

# variable "enforcement_level" {
#   type        = string
#   description = "Enforcement level of run task"
#   default     = "advisory"
# }

## project GH repo for root module matching the above LZ workspace we're deploying
#
variable "prefix" {
  type        = string
  description = "Name prefix prepended to name of LZ GH repository and LZ TFC project created"
  default     = "ml4"
}

variable "description" {
  type        = string
  description = "Repository for Terraform root module of landing zone"
}

variable "visibility" {
  type        = string
  description = "visibility of requested repository"
  default     = "private"
}

variable "has_issues" {
  type        = string
  description = "Specify whether or not this repository has issues"
  default     = false
}

variable "has_projects" {
  type        = string
  description = "Specify whether or not this repository has projects"
  default     = false
}

variable "gh_template_owner" {
  type        = string
  description = "The owner of the repository template e.g. ml4"
  default     = "ml4"
}

variable "template_name" {
  type        = string
  description = "The name of the repository template to use eg terraform-template-lz-module"
  default     = "terraform-template-lz-module"
}

variable "gh_token" {
  type        = string
  description = "The passed github PAT used by the null_resource to trigger the self-editing workflow on repo delivery"
  sensitive   = true
}

## LZ workspace
#
variable "hcpt_token" {
  type        = string
  description = "HCPT API token issued to the LZ workspace so it can deploy app-level HCPT config like more workspaces"
  sensitive   = true
}
