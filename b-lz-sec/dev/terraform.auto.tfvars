# tf_version = "1.11.1"

## main workspaces
#
workspaces = [
  # commented out for now as we're experimenting with only using stacks to deploy the whole shebang
  "c-dev-sec-lab",
  "c-int-sec-lab",
  "c-uat-sec-lab",
  "c-stg-sec-lab",
  "c-prd-sec-lab",
]

organization = "ml4"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "ml4"
  "Project" = "sec"
}
