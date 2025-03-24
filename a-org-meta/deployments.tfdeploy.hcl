## stack deployment configuration - closest thing to tfvars in stacks!
#

## HCP provider creds
#
store "varset" "hcp_provider_creds" {
  id       = "varset-8Cqze4exwfY4tE5D"
  category = "env"
}

## HC licences
#
store "varset" "app_licence_keys" {
  id       = "varset-jAGb9weKSqjC38Xm"
  category = "terraform"
}

## HCP provider creds
#
store "varset" "app_tls_certs_keys" {
  id       = "varset-UumEpkkf2bDzMiBA"
  category = "terraform"
}

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    organization = "ml4"

    ## ml4_net
    #
    identity_token = identity_token.aws.jwt

    ## hcp provider creds
    #
    HCP_CLIENT_ID     = store.varset.hcp_provider_creds.HCP_CLIENT_ID
    HCP_CLIENT_SECRET = store.varset.hcp_provider_creds.HCP_CLIENT_SECRET

    common_tags = {
      "Env"     = "dev"
      "Owner"   = "ml4"
      "Name"    = "" # stack-based landing zones deployed with this stack so set to nhull and let components override
      "Project" = "a-org-meta"
    }
  }
}

## orchestration
#
orchestrate "auto_approve" "dev" {
  check {
    # A condition that always evaluates to true
    condition = context.plan.applyable == true
    reason    = "Check always non-erroring configurations."
  }
}
