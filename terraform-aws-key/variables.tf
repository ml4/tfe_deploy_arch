variable "prefix" {
  type        = string
  description = "Currently, the prefix equals the whole key name"
}

variable "key" {
  type        = string
  description = "Public key used for accessing VMs in the VPC"
}
