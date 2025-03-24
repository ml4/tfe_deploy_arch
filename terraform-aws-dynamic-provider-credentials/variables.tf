## locals
#
locals {
  workload_identity_audience = "aws.workload.identity"
}

## REQUIRED VARIABLES
#
variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "organization_name" {
  type        = string
  description = "Organization name you want to build this within."
}

## OPTIONAL VARIABLES
#
variable "host_name" {
  type        = string
  description = "Host name of the TFE/TFC instance, defaults to the TFCB hostname of app.terraform.io"
  default     = "app.terraform.io"
}
