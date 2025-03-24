variable "key" {
  type        = string
  description = "Workspace variable key"
}

variable "value" {
  type        = string
  description = "Workspace variable value"
}

variable "category" {
  type        = string
  description = "Workspace variable category"
}

variable "workspace_id" {
  type        = string
  description = "Workspace ID"
  default     = null
}

variable "variable_set_id" {
  type        = string
  description = "Variable set ID"
  default     = null
}

variable "description" {
  type        = string
  description = "Description"
  default     = ""
}

variable "sensitive" {
  type        = string
  description = "Workspace variable sensitivity"
}
