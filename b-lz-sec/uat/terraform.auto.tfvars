# tf_version = "1.10.0"

## main workspaces
#
workspaces = [
  # commented out for now as we're experimenting with only using stacks to deploy the whole shebang
  "c-net-sec-lab",
  "c-svc-sec-lab",
  "c-dev-sec-lab",
  "c-int-sec-lab",
  "c-prd-sec-lab",
]

organization = "ml4"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "ml4"
  "Project" = "sec"
}
