data "aws_caller_identity" "current" {}

data "tls_certificate" "hcpt_certificate" {
  url = "https://${var.host_name}"
}

data "aws_iam_policy_document" "hcpt_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcpt_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.host_name}:aud"
      values   = [local.workload_identity_audience]
    }

    condition {
      test     = "StringLike"
      variable = "${var.host_name}:sub"
      values = [
        "organization:${data.tfe_organization.organization.name}:project:*:workspace:*:run_phase:plan",
        "organization:${data.tfe_organization.organization.name}:project:*:workspace:*:run_phase:apply",
        "organization:${data.tfe_organization.organization.name}:project:*:stack:*:*",
      ]
    }
  }
}

data "tfe_organization" "organization" {
  name = var.organization_name
}

