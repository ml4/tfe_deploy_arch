## variables.tf terraform configuration
#
variable "prefix" {
  type        = string
  description = "main prefix in front of most infra for multi-user accounts"
}

variable "common_tags" {
  type        = map(string)
  description = "tags common to all taggable resources"
  default     = {}
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to (e.g. eu-west-1)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
  default     = null
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "(Optional) List of public subnet CIDR ranges to create in VPC."
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "(Optional) List of private subnet CIDR ranges to create in VPC."
  default     = []
}
