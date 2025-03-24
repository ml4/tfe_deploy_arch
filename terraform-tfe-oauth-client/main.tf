resource "tfe_oauth_client" "main" {
  organization     = var.tfx_organization # TFE org not GitHub org
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.oauth_token # Pull code from account repos
  service_provider = "github"
}
