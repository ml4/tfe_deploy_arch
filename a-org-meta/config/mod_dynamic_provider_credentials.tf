module "dynamic-provider-credentials" {
  source            = "app.terraform.io/ml4/dynamic-provider-credentials/aws"
  version           = "1.0.27"
  aws_region        = var.primary_region
  organization_name = var.organization
  host_name         = "app.terraform.io"
}
