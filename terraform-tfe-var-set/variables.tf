variable "set_name" {
  type        = string
  description = "Variable set name"
}

variable "global" {
  type        = string
  description = "Whether or not set name is globally applied"
  default     = false
}

variable "project_name" {
  type        = string
  description = "A project to associate the var set with"
  default     = null
}

variable "organization" {
  type        = string
  description = "Organisation name"
}

variable "description" {
  type        = string
  description = "Description"
  default     = ""
}
