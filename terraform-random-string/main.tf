## Create a random string
## Example: CzPf68dp
#
resource "random_string" "random_string" {
  length           = var.length
  special          = var.special
  override_special = "_%@"
  upper            = var.upper
  lower            = var.lower
}
