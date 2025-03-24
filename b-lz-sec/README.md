
# b-lz-sec

Landing zone repository to version the code for your landing zone: arbitrary numbers of TFE or TFC workspaces and infrastructure objects required in addition to those foundational infrastructure provided to your team as per company policy. For example, this repo would deploy a three-tier architecture (LB, EC2 instances, RDS etc) but not the VPC and subnets - which would be deployed on your behalf by the Platform Team automated onboarding system.  Unless, of course, your company policy gives the app team a cloud account and free reign via efficient chargeback to deploy everything yourselves.

As this repository versions the root module used to deploy and configure TFC/E resources, only module calls to the private registry should be used to ensure maximum security.  

This repository should be owned by the Platform Team as it should be restricted to the deployment of objects including, but not limited to:
- TFC/E project
- TFC/E landing zone

## Auto Setup
- The repo includes a `global_replace.yml` GitHub Action which takes inputs from the repo vars and is triggered by a local-exec provisioner from the TF run which deploys it.  As such, you should see a README with the names of the project and owner used in the TF configuration.
- Also updated are the config/data.tf, the environment tfvars files and the main.tf file.

## What Next
- All you need to do to start is to add the workspaces you need in the LZ to the dev/dev.auto.tfvars for your dev environment and run Terraform against the code having cloned the resulting repo.

