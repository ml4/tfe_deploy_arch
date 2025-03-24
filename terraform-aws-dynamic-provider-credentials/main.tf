## main.tf terraform configuration
#
resource "aws_iam_openid_connect_provider" "hcpt_provider" {
  url             = "https://${var.host_name}"
  client_id_list  = [local.workload_identity_audience]
  thumbprint_list = ["${data.tls_certificate.hcpt_certificate.certificates.0.sha1_fingerprint}"]
}

resource "aws_iam_role" "hcpt_role" {
  name               = "hcpt-workload-identity-${var.organization_name}"
  assume_role_policy = data.aws_iam_policy_document.hcpt_role_trust_policy.json
}

## define var set
#
resource "tfe_variable_set" "dynamic_creds" {
  name         = "aws_dynamic_provider_credentials"
  description  = "Workspace vars needed for dynamic credentials"
  global       = true
  organization = data.tfe_organization.organization.name
}

resource "tfe_variable" "hcpt_aws_provider_auth" {
  key      = "TFC_AWS_PROVIDER_AUTH"
  value    = "true"
  category = "env"
  # workspace_id = tfe_workspace.workspace.id
  description     = "HCPT AWS provider auth variable"
  variable_set_id = tfe_variable_set.dynamic_creds.id
  sensitive       = false
}

resource "tfe_variable" "hcpt_aws_workload_identity_audience" {
  key      = "TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE"
  value    = local.workload_identity_audience
  category = "env"
  # workspace_id = tfe_workspace.workspace.id
  description     = "HCPT AWS dynamic credentials audience claim"
  variable_set_id = tfe_variable_set.dynamic_creds.id
  sensitive       = false
}

## Used because TFC_AWS_PLAN_ROLE_ARN and TFC_AWS_APPLY_ROLE_ARN are not being used
#
resource "tfe_variable" "hcpt_aws_run_role_arn" {
  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = aws_iam_role.hcpt_role.arn
  category = "env"
  # workspace_id = tfe_workspace.workspace.id
  description     = "HCPT AWS dynamic credentials role arn"
  variable_set_id = tfe_variable_set.dynamic_creds.id
  sensitive       = false
}

## additional policies to allow me to do stuff in my account
#
resource "aws_iam_policy" "PowerUserAccess" {
  name        = "hcpt-PowerUserAccess-${var.organization_name}"
  description = "HCPT run policy - PowerUserAccess"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "PowerUserAccess",
            "NotAction": [
                "account:*",
                "iam:*",
                "organizations:*",
                "rolesanywhere:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hcpt_policy_attachment" {
  role       = aws_iam_role.hcpt_role.name
  policy_arn = aws_iam_policy.PowerUserAccess.arn
}

resource "aws_iam_policy" "IAMAllowMutate" {
  name        = "hcpt-IAMAllowMutate-${var.organization_name}"
  description = "HCPT run policy - IAMAllowMutate"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowIAM",
            "Action": [
                "iam:AttachRolePolicy",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PutRolePolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:UpdateRole",
                "iam:UpdateRoleDescription",
                "iam:PassRole",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:TagInstanceProfile",
                "iam:UntagInstanceProfile",
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:UpdateAccessKey",
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ResyncMFADevice",
                "iam:DeleteUserPolicy",
                "iam:PutUserPolicy",
                "iam:GenerateOrganizationsAccessReport",
                "iam:CreateServiceLinkedRole",
                "iam:DeleteServiceLinkedRole",
                "iam:UpdateServerCertificate",
                "iam:UploadServerCertificate",
                "iam:DeleteServerCertificate",
                "rolesanywhere:Delete*",
                "rolesanywhere:Disable*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hcpt_IAMAllowMutate" {
  role       = aws_iam_role.hcpt_role.name
  policy_arn = aws_iam_policy.IAMAllowMutate.arn
}

resource "aws_iam_policy" "IAMAllowMutatePoliciesAndPasswd" {
  name        = "hcpt-IAMAllowMutatePoliciesAndPasswd-${var.organization_name}"
  description = "HCPT run policy - IAMAllowMutatePoliciesAndPasswd"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "PoliciesAndPassword",
            "Action": [
                "iam:ChangePassword",
                "iam:DeleteLoginProfile",
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion",
                "iam:TagPolicy",
                "iam:UntagPolicy"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hcpt_IAMAllowMutatePoliciesAndPasswd" {
  role       = aws_iam_role.hcpt_role.name
  policy_arn = aws_iam_policy.IAMAllowMutatePoliciesAndPasswd.arn
}

resource "aws_iam_policy" "OrgAndIAMReadOnlyAccess" {
  name        = "hcpt-OrgAndIAMReadOnlyAccess-${var.organization_name}"
  description = "HCPT run policy - OrgAndIAMReadOnlyAccess"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ReadOnly",
            "Action": [
                "rolesanywhere:Get*",
                "rolesanywhere:List*",
                "organizations:Describe*",
                "organizations:List*",
                "iam:Generate*",
                "iam:Get*",
                "iam:List*",
                "iam:Simulate*",
                "account:ListRegions"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hcpt_OrgAndIAMReadOnlyAccess" {
  role       = aws_iam_role.hcpt_role.name
  policy_arn = aws_iam_policy.OrgAndIAMReadOnlyAccess.arn
}
