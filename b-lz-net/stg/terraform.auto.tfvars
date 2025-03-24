# tf_version = "1.10.0"

## main workspaces
#
workspaces = [
  # commented out for now as we're experimenting with only using stacks to deploy the whole shebang
  "c-net-net-lab",
  "c-svc-net-lab",
  "c-dev-net-lab",
  "c-int-net-lab",
  "c-prd-net-lab",
]

organization = "ml4"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "ml4"
  "Project" = "net"
}
