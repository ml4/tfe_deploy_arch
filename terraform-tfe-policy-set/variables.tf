variable "policy_name" {
  type        = string
  description = "TFE policy name"
}

variable "policy_description" {
  type        = string
  description = "TFE policy description"
}

variable "policy_organization" {
  type        = string
  description = "TFE policy organization"
}

variable "global" {
  type        = string
  description = "TFE global"
}

variable "workspace_ids" {
  type        = list(any)
  description = "TFE workspace IDs"
  default     = []
}

variable "policy_path" {
  type        = string
  description = "TFE policy path"
}

variable "policy_repository" {
  type        = string
  description = "TFE policy repository"
}

variable "policy_repository_branch" {
  type        = string
  description = "TFE policy repository branch"
}

variable "oauth_token_id" {
  type        = string
  description = "TFE OAuth token ID"
}
