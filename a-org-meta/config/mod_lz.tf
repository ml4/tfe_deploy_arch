## The landing zone modules should not be supplied with parameters which might be updated by the platform team afterwards, such as during a zero day patching exercise.  Terraform version being the main one.
## The idea here is that we deploy LZ workspaces, and then update the tf version in them separately via API, and then run them (to mimic the owning dev team doing this themselves or to mimic a platform team doing it en mas).
#

module "b-lz-net" {
  source            = "app.terraform.io/ml4/lz/tfe"
  version           = "1.0.57"
  auto_apply        = true
  prefix            = var.prefix
  hcpt_org          = var.organization     # hcpt object context
  gh_template_owner = var.organization     # gh  object context
  template_name     = var.gh_template_name # gh  repo template
  gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
  hcpt_project      = "net"
  lz_project_id     = module.b-lz-project.tp-tp-main-id
  description       = "LZ - network team"
  hcpt_token        = var.hcpt_token
  tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
}

module "b-lz-sec" {
  source            = "app.terraform.io/ml4/lz/tfe"
  version           = "1.0.57"
  auto_apply        = true
  prefix            = var.prefix
  hcpt_org          = var.organization     # hcpt object context
  gh_template_owner = var.organization     # gh  object context
  template_name     = var.gh_template_name # gh  object context
  gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
  hcpt_project      = "sec"
  lz_project_id     = module.b-lz-project.tp-tp-main-id
  description       = "LZ - security team"
  hcpt_token        = var.hcpt_token
  tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
}

# module "b-lz-team1" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "one"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team one"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team2" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "two"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team two"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team3" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "three"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team three"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team4" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "four"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team four"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team5" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "five"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team five"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team6" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "six"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team six"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team7" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "seven"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team seven"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-team8" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "eight"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "LZ - team eight"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-consul" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "consul"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "Phase b: lz - consul team"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-nomad" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "nomad"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "Phase b: lz - nomad team"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-terraform" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "terraform"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "Phase b: lz - terraform team"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-vault" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "vault"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "Phase b: lz - vault team"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }

# module "b-lz-waypoint" {
#   source            = "app.terraform.io/ml4/lz/tfe"
#   version           = "1.0.57"
#   auto_apply        = true
#   prefix            = var.prefix
#   hcpt_org          = var.organization     # hcpt object context
#   gh_template_owner = var.organization     # gh  object context
#   template_name     = var.gh_template_name # gh  object context
#   gh_token          = var.gh_token         # used to trigger the self-editing workflow on deployment
#   hcpt_project      = "waypoint"
#   lz_project_id     = module.b-lz-project.tp-tp-main-id
#   description       = "Phase b: lz - waypoint-based app team"
#   hcpt_token        = var.hcpt_token
#   tf_version        = var.tf_version # adding this back in as need hand control of the version passed to the lz mod
# }
