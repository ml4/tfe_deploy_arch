variable "org" {
  type        = string
  description = "Organisation name"
}

variable "repository" {
  type        = string
  description = "Main connected repository name"
}

variable "oauth_token" {
  type        = string
  description = "OAuth token required for ingress"
}
