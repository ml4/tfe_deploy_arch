# AWS Dynamic Provider Credentials - CLI-driven workspace

## Prerequisites
- You will need access to a TFC organization.
- You will need access to an AWS Account where you have sufficient permissions to create an OIDC provider.
- You will need to run this module in a workspace with AWS authorization already configured
- Add one or more permissions policies to the role created by this config. To do this using Terraform, add a file, e.g. `policies.tf` with one or more policies as follows:

```
resource "aws_iam_policy" "IAMExamplePolicy" {
  name        = "tfc-IAMExamplePolicy"
  description = "TFC run policy - IAMExamplePolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            # Your permissions policy here
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tfc_IAMExamplePolicy" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.IAMExamplePolicy.arn
}
```

## Running

To enable dynamic credentials in an existing workspace, tag the workspace with `aws_dyn_creds`.

After providing the necessary variables, running a terraform apply of this module should provide you with a variable set where the following environment variables are set

- TFC_AWS_PROVIDER_AUTH
- TFC_AWS_RUN_ROLE_ARN
- TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE

This variable set will be shared with all workspaces with the `aws_dyn_creds` tag.

If any of these are missing, something has gone wrong with the module.

You should now be set up to run through the rest of the [Dynamic Provider Credentials docs](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration). Happy Terraforming!

## After Apply

Head to the workspace and copy the cloud stanza into a terraform configuration and you can leverage the AWS role to create & destroy infrastructure with a CLI based workspace.

The AWS role created via this module will have no permissions. You can manually add permissions to it via the Amazon UI, or you can amend this module to include a policy document or in line policy code such as [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)

Due to the variation in how users choose to attach policies, this module does not enforce any way and is instead expected to be forked or adapted to how users wish to use it.

Amazon providers it's own [Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html) which could be useful to you if wanting to create policies following least privilege.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.42.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.42.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.tfc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.AllowMutateIAM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.AllowMutateIAMPoliciesAndPassword](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.IAMAndOrgReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.PowerUserAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.tfc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.tfc_AllowMutateIAM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfc_AllowMutateIAMPoliciesAndPassword](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfc_IAMAndOrgReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfc_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [tfe_variable.tfc_aws_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_aws_run_role_arn](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_aws_workload_identity_audience](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.dynamic_creds](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.tfc_role_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tfe_organization.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/organization) | data source |
| [tls_certificate.tfc_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | # REQUIRED VARIABLES | `string` | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | Host name of the TFE/TFC instance, defaults to the TFCB hostname of app.terraform.io | `string` | `"app.terraform.io"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Organization name you want to build this within. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tvs-tvs-dynamic_creds-id"></a> [tvs-tvs-dynamic\_creds-id](#output\_tvs-tvs-dynamic\_creds-id) | TFE Variable Set id |
<!-- END_TF_DOCS -->