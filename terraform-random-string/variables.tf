variable "length" {
  type        = number
  description = "The length of the password"
  default     = 8
}

variable "special" {
  type        = bool
  description = "Whether to include special characters"
  default     = false
}

variable "upper" {
  type        = bool
  description = "Whether to include uppercase characters"
  default     = true
}

variable "lower" {
  type        = bool
  description = "Whether to include lowercase characters"
  default     = true
}
