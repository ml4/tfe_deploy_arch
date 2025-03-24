## key.tf terraform configuration
#
resource "aws_key_pair" "main" {
  key_name   = var.prefix
  public_key = var.key
}
