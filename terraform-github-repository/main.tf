resource "github_repository" "main" {
  name        = var.name
  description = var.description

  visibility   = var.visibility
  has_issues   = var.has_issues
  has_projects = var.has_projects

  template {
    owner      = var.template_owner
    repository = var.template_name
  }
}

resource "github_actions_secret" "main" {
  repository      = var.name
  for_each        = var.secrets
  secret_name     = each.key
  plaintext_value = each.value
}
