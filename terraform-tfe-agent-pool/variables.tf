variable "pool_name" {
  type        = string
  description = "Name of the agent pool to create"
}

variable "organization" {
  type        = string
  description = "Name of the organization in which to create the agent pool"
}

variable "tfe_agent_token_description" {
  type        = string
  description = "Description to add to the creation of the token - helps UI consumption"
}

