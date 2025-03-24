# a-org-meta

Python script to deploy the top level TFC organization setup:
- Packer run task (enterprise required - specific to HashiCorp demonstrations)
- HCPT project a-org-meta - lab 0th level only, with workspace deployed by API in which to run top-level OIDC, DNS, agent pools. b-lz projects are created for example subordinate c-level app team env workspaces.
- Stack deployment of components for 6-region landing zone containing:

## stacks
- Run doormat refresh to get some HCPT creds
- Run api/genesis.py to setup the space and initial workspace vars for the landing zone run setup
  - agent pools
  - DNS config in R53
  - Dynamic AWS creds = OIDC
- Run this stacks code for the a-org-meta stack. Given the significance of it then running automatically in order to boot a whole platform in one AWS account sounds more like a business vertical/LoB deploy where the devsecops team deploy and own their own network, and the deployment of the apps into it, via stacks in the same top-level project.
- As such, we conflate the use of a-org-meta to deploy the DNS/OIDC part AND the stacks needed to deploy the infra needed to support the service deployment (even if we don't deploy them as part of the stack, but I'd like to), based on:
    - net = network services     = all network objects
    - pfs = platform services    = devsecops = SSH keys/bastions, vault, consul
    - app = application services = nomad svrs, nomad clients, service deployments
- rationale is business vertical that would have one AWS account but then deploy whatever in it, and thus has internal devsecops owning all infra for the app team(s) within - can extrapolate to whole organization easily with LZs being app teams with subordinate traditional workspaces such as in the config subdirectory.
2025-01-12

