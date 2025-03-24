## common
#
variable "prefix" {
  type        = string
  description = "prefix"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "primary_region" {
  type        = string
  description = "Primary region"
}

# variable "secondary_region" {
#   type        = string
#   description = "AWS secondary region"
# }

# variable "tertiary_region" {
#   type        = string
#   description = "AWS tertiary region"
# }

# variable "quaternary_region" {
#   type        = string
#   description = "AWS quaternary region"
# }

# variable "quinary_region" {
#   type        = string
#   description = "AWS quinary region"
# }

# variable "senary_region" {
#   type        = string
#   description = "AWS senary region"
# }

## hvs_vlt_cli_tfvars
#
variable "_HCP_CLIENT_ID" {
  type        = string
  description = "Used for HVS vlt CLI access"
  validation {
    condition     = length(var._HCP_CLIENT_ID) > 0
    error_message = "The _HCP_CLIENT_ID variable cannot be empty"
  }
}

variable "_HCP_CLIENT_SECRET" {
  type        = string
  description = "Used for HVS vlt CLI access"
  validation {
    condition     = length(var._HCP_CLIENT_SECRET) > 0
    error_message = "The _HCP_CLIENT_SECRET variable cannot be empty"
  }
}

variable "_HCP_ORGANIZATION_ID" {
  type        = string
  description = "Used for HVS vlt CLI access"
  validation {
    condition     = length(var._HCP_ORGANIZATION_ID) > 0
    error_message = "The _HCP_ORGANIZATION_ID variable cannot be empty"
  }
}

variable "_HCP_PROJECT_ID" {
  type        = string
  description = "Used for HVS vlt CLI access"
  validation {
    condition     = length(var._HCP_PROJECT_ID) > 0
    error_message = "The _HCP_PROJECT_ID variable cannot be empty"
  }
}
