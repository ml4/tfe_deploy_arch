# tf_version = "1.11.1"

## main workspaces
#
workspaces = [
  # commented out for now as we're experimenting with only using stacks to deploy the whole shebang
  "c-dev-net-lab",
  "c-int-net-lab",
  "c-uat-net-lab",
  "c-stg-net-lab",
  "c-prd-net-lab",
]

organization = "ml4"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "ml4"
  "Project" = "net"
}
