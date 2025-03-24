variable "name" {
  type        = string
  description = "Name of requested repository"
}

variable "description" {
  type        = string
  description = "Description of requested repository"
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

variable "template_owner" {
  type        = string
  description = "The owner of the repository template"
}

variable "template_name" {
  type        = string
  description = "The name of the repository template"
}

variable "secrets" {
  type        = map(any)
  description = "KV map of repository secrets, mostly for things like GitHub Actions"
  default     = {}
}
