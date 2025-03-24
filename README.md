# tfe_deploy_arch
<<<<<<< HEAD
=======

This repo is a collection of resources which can be used to shift the TFE onboarding process left so that the platform team is hands off e2e. That is the target. However, this repo only contains Terraform code for automation and does not include additional logic required to integrate AAD, ServiceNow or other enterprise platforms at your organisation - code for that will always be site-specific so is omitted.

The subdirectories in this repo are equivalent to the gitroots in the repositories named per each directory name. The git directories have been removed to allow ingress into which ever VCS is required as a starting point.

NOTES:
- Terraform child modules are in directories beginning `terraform-`
  - Some modules only have one resource. This is fine because you're seeking standardisation across the platform from an SDLC perspective. Keep Terraform `resource` stanzas out of workspace configurations - have module calls only.
- Terraform root modules == example code used to call the child modules are in directories which begin `[abc]-` depending on the layer as described in the architecture diagram.
- Your implementation will be different - take this content as a ffwd on your own work.
- The code comes without warrantee or indemnification. Always read and understand the code prior to running it, and especially not in production.
- Included is also a policy-as-code directory of some policies - this can be attached as a policy set to TFE and applied as you see fit. Apply limitations on all workspaces so that they must use modules from the registry and that they are versioned.  This ensures maximal reusability of all the child mods in your private reg.
- You will note in the child mod outputs.tf a d-e-f-g nomenclature which is the author's, brought from previous work and goes with the a-b-c root module outputs. The approach was used because of a need to formulate standard output names so that they could be machined at scale, originally in order to allow a pipeline to access the outputs (dynamic names such as vpc ID) and then use these to do config management across k8s in the order of thousands of objects. It thus may have a use, but the resource abbreviations are possibly a bit confusing so an alternative nomeclature would be recommended. Also, HashiCorp have stacks coming, so post-deploy config mgmt is probably better done with onward providers e.g. workspace deploy k8s, k8s provider to config, or stacks deploy vault and vault provider to config etc. Also note we of course now recommend Ansible for all post-boot config mgmt.
- Where a TFE FQDN is used, app.terraform.io is in place as the contents of this repo is currently used with HCP Terraform, not a specific TFE instance. Change as needed.
- Current versions.tf cite terraform binary >= 1.10.0 - this needs updating in due course.
- Terraform-docs is the only recommended adjunct functionality we recommend - this is implemented here per a macOS implementation installed with brew. See the terraform-template-child-module directory/README.md for the example hook call in the regard. While this is optional, having an up-to-date README is key to your code community.
- The VPC mod is basic and included for reference. The ACL is set to null, so the code purports reliance on SGs for security. It is recommended to tighten this up should it be usable - like all the recources here, pull in all the useful bit to get going quicker.
- There are no tests/ directories in the child modules, but there should be; this is a point in time in the work of the author and is an outstanding task.
- The directories `terraform-template-*` are not terraform modules per se, but github repository templates, so once you have instantiated them in your VCS, can be used to create standardised repositories usable for IaC onwards.
- The terraform-template-lz-module has github actions used to be called using a provisioner. This is a convenience function. HashiCorp recommend provisioners as a last resort and this was added to speed up deployment of landing zone repositories for demonstration. Rework the concept to your VCS accordingly.
- Logic seen here suggests passing of GitHub and TFE tokens - this is to facilitate the deployment of TFE config subsequent to the LZ dropping. Note that they are demo tokens, so where you need tokens to make stuff happen should be construed as needing examination in the context of your security policy. You may see HCP creds being passed as both env and terraform vars - env for access to HCP Packer (which is where the author stores image metadata) and terraform so they can be passed to nascent infra which can then auth to HCP Vault Secrets (HVS) as this was where pipeline secrets were stored. New HVD modules do not currently use HVS so this logic is somewhere pending. Keep your wits about you.
- Not all child mods are used in the workspace configs; some are included for interest in case they are useful. Notably, a child mod to manage the inclusion of a child module in the private mod reg. The author does not use this and experimentation should be done in dev if you are thinking of doing this as state representation for the mod catalogue may be deemed superfluous.
- In the a-org-meta/api directory are scripts the author uses to set up and manage the 'platform team' top-level project/workspace setup. There are references to personal items which are irrelevant to your site:
  - pi-ccn.org is a personal domain
  - "{os.environ['HOME']}/.aws_regions" is used to store regions which the author deploys to and thus iterates over:
```
$ cat ~/.aws_regions
## .aws_regions
## a better way to get regions into the build process given that bash arrays in rc files is a bind
eu-north-1,10.0.0.0/16
eu-central-1,10.32.0.0/16
us-west-2,10.64.0.0/16
ca-central-1,10.96.0.0/16
ap-southeast-2,10.128.0.0/16
ap-northeast-1,10.160.0.0/16
```
  - genesis.py is included to show an example python script for consuming the TFE API to set stuff up. API to start standardises approach and avoids click-ops but is largely useful to initiate a new instance so is not run very often. Note it also solicits secrets instantiated into the calling shell which need to be there to proceed.
  - Addition of HashiCorp licence keys to the platform team workspace is needed for personal ease of use and we recomment use of pipeline secrets instead for actual deployment.
  - tf_version_update.py is a stab at day2 ops re proffering a new terraform binary version to landing zone repos so that they can be rerun and update the c-level app workspaces to keep the requirements up-to-date. Use needs careful consideration and experimentation.
  - write_asm_pipeline_secrets.sh is a convenience script to write cert data to ASM to be drawn down by HashiCorp HVD module deployments. It has limited use and is included for reference.
- The a-org-meta repo is currently doubling as an experimentation area for Terraform Stacks. The stacks deploy currently deploys a 6-AWS-region peered hub-and-spoke VPC network topology with 6-region Vault (with no config yet) and (currently public subnet only) TFE instance (also with no config). The config is part-completed but does deploy objects. Help yourself - Stacks is still beta at time of writing, so this should be of interest to show how we will be deploying large-scale IaC from this Summer onwards.
- c-team-net has been added to with example code to deploy a network team VPC setup (separate from the stacks on but using the same mod(s)). As the b-landing zone repo for this (b-lz-net) was a template, this has to be committed 'by the app team, after the platform team provides it'.
- The hc-sec-pac repo has a standard module structure but does not need the dev/sit/prd subdirectories - it was bastardised from the terraform-template-child-module repo. Keep your PaC in a monorepo as it will be more convenient and even a bank will not add more code than would conveniently fit in one repo. All other code should be separated by repo.

@ml4 Mar 2025

Let your HashiCorp account team know if you have any questions.

>>>>>>> 26c8c8d (Add initial)
