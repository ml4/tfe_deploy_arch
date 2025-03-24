module "opa" {
  source = "../common-functions/opa-functions/opa.sentinel"
}

policy "policy" {
  source = "./policy.sentinel"
  enforcement_level = "hard-mandatory"
}

