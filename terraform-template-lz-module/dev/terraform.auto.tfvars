# tf_version = "1.11.1"

## main workspaces
#
workspaces = [
  # commented out for now as we're experimenting with only using stacks to deploy the whole shebang
  "c-dev-%%PROJECT_NAME%%-lab",
  "c-int-%%PROJECT_NAME%%-lab",
  "c-uat-%%PROJECT_NAME%%-lab",
  "c-stg-%%PROJECT_NAME%%-lab",
  "c-prd-%%PROJECT_NAME%%-lab",
]

organization = "%%OWNER_NAME%%"
common_tags = {
  "Env"     = "dev"
  "Owner"   = "%%OWNER_NAME%%"
  "Project" = "%%PROJECT_NAME%%"
}
