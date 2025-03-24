#!/usr/bin/env python3
#
## genesis.py
## 2023:05:02::@ml4
## Initialize the pipe - tfc api - expects owners users/team API token; does not expect pages of workspaces etc.
#
###############################################################################################################################################

## Imports
#
import boto3
import datetime
import inspect
import json
import os
import subprocess
import sys
import re
import requests

## Globals
#
api_response = ''
SCRIPT_NAME  = os.path.basename(__file__)
tfe_org      = 'ml4'
aws_region   = 'eu-north-1'
nightshade   = os.path.expanduser('~/Keep/nightshade')
domain       = 'aws.pi-ccn.org'

hcp_run_task_name = 'hcpp'
hcp_run_task_url = 'https://api.cloud.hashicorp.com/packer/2021-04-30/terraform-cloud/validation/b0c940ce-f277-45c5-a1e0-c9477f7e2779'  # path to ml4 hcpp hcp run task

## read in ${HOME}/.aws_regions and instantiate an internal global array of regions - remember to do a grep -v of ^# to ignore comments in the file
#
def get_regions():
  regions = []
  with open(f"{os.environ['HOME']}/.aws_regions", "r") as f:
    for line in f:
      if not re.match(r'^#', line):
        regions.append(line.split(",")[0].strip())
  return regions

###############################################################################################################################################
#
def draw_line(colour=None):
  set_colour = ""
  if not colour:
    colour = "white"

  if colour == "red":
    set_colour = "\033[1;31m"
  elif colour == "green":
    set_colour = "\033[1;32m"
  elif colour == "yellow":
    set_colour = "\033[1;33m"
  elif colour == "blue":
    set_colour = "\033[1;34m"
  elif colour == "purple":
    set_colour = "\033[1;35m"
  elif colour == "cyan":
    set_colour = "\033[1;36m"
  else:
    set_colour = "\033[1;37m"

  if not os.getenv("TERM") or os.getenv("TERM") == "unknown" or os.getenv("TERM") == "dumb":
    columns = os.getenv("COLUMNS", 172)
  else:
    columns = os.getenv("COLUMNS", os.popen("tput cols").read().strip())

  print(f"{set_colour}{'*' * int(columns)}\033[0m")
###############################################################################################################################################
#
def log(level, func, message):
  bldred = '\033[1;31m' # Red
  bldgrn = '\033[1;32m' # Green
  bldylw = '\033[1;33m' # Yellow
  bldblu = '\033[1;34m' # Blue
  bldpur = '\033[1;35m' # Purple
  bldcyn = '\033[1;36m' # Cyan
  bldwht = '\033[1;37m' # White
  wht = '\033[0;37m' # White
  txtrst = '\033[0m'    # Text Reset

  if level == "INFO":
    COL = bldgrn
  elif level == "ERROR":
    COL = bldred
  elif level == "WARN":
    COL = bldylw

  timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S %Z')
  print(f'{bldcyn}{timestamp}{txtrst} [{COL}{level}{txtrst}] {wht}[{SCRIPT_NAME}:{func}] {message}{txtrst}', file=sys.stderr)

###############################################################################################################################################
#
def run_request(hcpt_token, url, payload, type):
  headers = {
    "Authorization": f"Bearer {hcpt_token}",
    "Content-Type": "application/vnd.api+json",
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting {url}")
  if type == "get":
    # log("WARN", inspect.currentframe().f_code.co_name, f"REQUESTS CALL: URL: {url} payload: {json.dumps(payload).encode('utf-8')}")
    r = requests.get(url, headers=headers, data=json.dumps(payload).encode("utf-8"))
  elif type == "post":
    # log("WARN", inspect.currentframe().f_code.co_name, f"REQUESTS CALL: URL: {url} payload: {json.dumps(payload).encode('utf-8')}")
    r = requests.post(url, headers=headers, data=json.dumps(payload).encode("utf-8"))

  if r.status_code > 399 and r.status_code != 422:
    log("ERROR", inspect.currentframe().f_code.co_name, f"\033[0;37m{r.status_code}: Failure code returned.\033[0m")
    log("ERROR", inspect.currentframe().f_code.co_name, f"\033[0;37mtext: {r.text}\033[0m")
    exit(r.status_code)
  elif r.status_code == 422:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[0;37m{r.status_code}: Requested item already exists.\033[0m")
    log("WARN", inspect.currentframe().f_code.co_name, f"\033[0;37mtext: {r.text}\033[0m")
    return(r)
  elif r.status_code == 200:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;37m{r.status_code}: OK.\033[0m]")
    return(r)
  elif r.status_code == 201:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;37m{r.status_code}: Requested item created OK.\033[0m]")
    return(r)
  elif r.status_code == 204:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;37m{r.status_code}: OK.\033[0m]")
    return(r)
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"\033[1;37m{r.status_code}: Requested failed\033[0m]")
    exit(r.status_code)

###############################################################################################################################################
#
def add_org_run_task(runtask_name, runtask_URL, runtask_HMAC, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/tasks"
  payload = {
    "data": {
      "type": "tasks",
      "attributes": {
        "name": f"{runtask_name}",
        "url": f"{runtask_URL}",
        "description": "Run Task created by pipe-init.sh",
        "hmac_key": f"{runtask_HMAC}",
        "enabled": "true",
        "category": "task"
      }
    }
  }
  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new organisation run task \033[0m|\033[1;34m{hcp_run_task_name}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")
  return(r)

###############################################################################################################################################
#
def get_project_id(project_name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/projects"
  payload = {}

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting project id for project |{project_name}|")
  r = run_request(hcpt_token, url, payload, "get")
  data = json.loads(r.text)

  for project in data["data"]:
    if project["attributes"]["name"] == project_name:
      log("INFO", inspect.currentframe().f_code.co_name, f"Found project |{project['id']}|")
      return project["id"]

  log("ERROR", inspect.currentframe().f_code.co_name, f"Project '{project_name}' not found.")
  exit(1)

###############################################################################################################################################
#
def new_project(project, hcpt_token, LAB_TFC_HOSTNAME):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/projects'
  payload = {
    "data": {
      "attributes": {
        "name": f"{project}"
      },
      "type": "projects"
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new project: \033[0m|\033[1;32m{project}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")

  ## if the result is a 422, we then need to extract the ID for the existing object
  #
  if r.status_code == 422:
    project_id = get_project_id(project, hcpt_token, LAB_TFC_HOSTNAME)
    return(project_id)
  elif r.status_code == 201:
    data = json.loads(r.text)
    project_id = data['data']['id']
    log("INFO", inspect.currentframe().f_code.co_name, f"{r.status_code}: Project \033[0m|\033[1;32m{project}\033[0m| created: \033[0m|\033[1;32m{project}\033[0m|")
    return(f'{project_id}')
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"{r.status_code}: Not got a 422 already exists or 201 created code.")
    r.text
    exit(r.status_code)

###############################################################################################################################################
#
# def new_stack(project, hcpt_token, LAB_TFC_HOSTNAME):
## NEEDS WRITING FROM HERE AND NOT SUPPORTED YET
#   url = f'https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/projects'
#   payload = {
#     "data": {
#       "attributes": {
#         "name": f"{project}"
#       },
#       "type": "projects"
#     }
#   }

#   log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new project: \033[0m|\033[1;32m{project}\033[0m|")
#   r = run_request(hcpt_token, url, payload, "post")

#   ## if the result is a 422, we then need to extract the ID for the existing object
#   #
#   if r.status_code == 422:
#     project_id = get_project_id(project, hcpt_token, LAB_TFC_HOSTNAME)
#     return(project_id)
#   elif r.status_code == 201:
#     data = json.loads(r.text)
#     project_id = data['data']['id']
#     log("INFO", inspect.currentframe().f_code.co_name, f"{r.status_code}: Project \033[0m|\033[1;32m{project}\033[0m| created: \033[0m|\033[1;32m{project}\033[0m|")
#     return(f'{project_id}')
#   else:
#     log("ERROR", inspect.currentframe().f_code.co_name, f"{r.status_code}: Not got a 422 already exists or 201 created code.")
#     r.text
#     exit(r.status_code)


###############################################################################################################################################
#
def get_workspace_id(workspace_name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/workspaces"
  payload = {}

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting workspace id for workspace |{workspace_name}|")
  r = run_request(hcpt_token, url, payload, "get")
  data = json.loads(r.text)

  for workspace in data["data"]:
    if workspace["attributes"]["name"] == workspace_name:
      log("INFO", inspect.currentframe().f_code.co_name, f"Found workspace |{workspace['id']}|")
      return workspace["id"]

  log("ERROR", inspect.currentframe().f_code.co_name, f"Project '{workspace_name}' not found.")
  exit(1)

###############################################################################################################################################
#
def new_workspace(workspace, project_id, hcpt_token, LAB_TFC_HOSTNAME):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/workspaces'
  payload = {
    "data": {
      "type": "workspaces",
      "attributes": {
        "name": f"{workspace}",
        "resource-count": 0,
        "auto-apply": True
      },
      "relationships": {
        "project": {
          "data": {
            "type": "projects",
            "id": f"{project_id}"
          }
        }
      }
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new workspace \033[0m|\033[1;33m{workspace}\033[0m| in project |{project_id}|")
  r = run_request(hcpt_token, url, payload, "post")

  ## if the result is a 422, we then need to extract the ID for the existing object
  #
  if r.status_code == 422:
    workspace_id = get_workspace_id(workspace, hcpt_token, LAB_TFC_HOSTNAME)
    return(workspace_id)
  elif r.status_code == 201:
    return(r.json()['data']['id'])
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"{r.status_code}: Not got a 422 already exists or 201 created code.")
    r.text
    exit(r.status_code)

###############################################################################################################################################
#
def new_workspace_variable(workspace_id, var_type, key, value, sensitive, hcpt_token, LAB_TFC_HOSTNAME):
  # Ensure sensitive is a boolean
  sensitive_bool = True if str(sensitive).lower() == 'true' else False

  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/workspaces/{workspace_id}/vars'
  payload = {
    "data": {
      "type":"vars",
      "attributes": {
        "key":f"{key}",
        "value":f"{value}",
        "category": f"{var_type}",
        "hcl":"false",
        "sensitive": sensitive_bool
      }
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new workspace variable \033[0m|\033[1;35m{key}\033[0m| in workspace \033[0m|\033[1;33m{workspace_id}\033[0m| - sensitive \033[0m|\033[1;31m{sensitive}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")
  return(r)

###############################################################################################################################################
#
def get_varset_id(varset_name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/varsets"
  payload = {}

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting varset id for varset |{varset_name}|")
  r = run_request(hcpt_token, url, payload, "get")
  data = json.loads(r.text)

  for varset in data["data"]:
    if varset["attributes"]["name"] == varset_name:
      log("INFO", inspect.currentframe().f_code.co_name, f"Found varset |{varset['id']}|")
      return varset["id"]

  log("ERROR", inspect.currentframe().f_code.co_name, f"Project '{varset_name}' not found.")
  exit(1)

###############################################################################################################################################
#
def new_global_variable_set(name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/varsets'
  payload = {
    "data": {
      "type": "varsets",
      "attributes": {
        "name": f"{name}",
        "description": "Variable set to be used by all workspaces",
        "global": True
      }
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new global variable set \033[0m|\033[1;31m{name}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")

  ## if the result is a 422, we then need to extract the ID for the existing object
  #
  if r.status_code == 422:
    varset_id = get_varset_id(name, hcpt_token, LAB_TFC_HOSTNAME)
    return(varset_id)
  elif r.status_code == 201:
    return(r.json()['data']['id'])
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"{r.status_code}: Not got a 422 already exists or 201 created code.")
    r.text
    exit(r.status_code)

  return(r)

###############################################################################################################################################
#
def new_non_global_variable_set(name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/varsets'
  payload = {
    "data": {
      "type": "varsets",
      "attributes": {
        "name": f"{name}",
        "description": "Full of vars and such for mass reuse",
        "global": False
      }
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mCreating new global variable set \033[0m|\033[1;31m{name}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")

  ## if the result is a 422, we then need to extract the ID for the existing object
  #
  if r.status_code == 422:
    varset_id = get_varset_id(name, hcpt_token, LAB_TFC_HOSTNAME)
    return(varset_id)
  elif r.status_code == 201:
    return(r.json()['data']['id'])
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"{r.status_code}: Not got a 422 already exists or 201 created code.")
    r.text
    exit(r.status_code)

  return(r)

###############################################################################################################################################
#
def add_variable_to_set(varset_id, key, value, sensitive, category, desc, hcpt_token, LAB_TFC_HOSTNAME):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/varsets/{varset_id}/relationships/vars'
  payload = {
    "data": {
      "type": "vars",
      "attributes": {
        "key": f'{key}',
        "value": f'{value}',
        "description": f'{desc}',
        "sensitive": sensitive,
        "category": category,
        "hcl": False
      }
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mAdding new variable \033[0m|\033[1;35m{key}\033[0m| \033[1;36mto variable set \033[0m|\033[1;31m{varset_id}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")
  return(r)

###############################################################################################################################################
#
def add_variable_set_to_workspace(varset_id, hcpt_token, LAB_TFC_HOSTNAME, workspace_id):
  url = f'https://{LAB_TFC_HOSTNAME}/api/v2/varsets/{varset_id}/relationships/workspaces'
  payload = {
    "data": [
      {
        "type": "workspaces",
        "id": f"{workspace_id}"
      }
    ]
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mAdding variable set \033[0m|\033[1;35m{varset_id}\033[0m| \033[1;36mto workspace \033[0m|\033[1;33m{workspace_id}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")
  return(r)

#    #   ##   # #    #
##  ##  #  #  # ##   #
# ## # #    # # # #  #
#    # ###### # #  # #
#    # #    # # #   ##
#    # #    # # #    #

## main
#
def main():
  ## source API token
  #
  credentials_file = os.path.join(os.environ["HOME"], ".terraform.d/credentials.tfrc.json")
  if not os.path.isfile(credentials_file):
    log("ERROR", inspect.currentframe().f_code.co_name, "No ~/.terraform.d/credentials.tfrc.json")
    return 1

  ## read in the aws regions
  #
  regions = get_regions()

  ## ensure critical environment variables are instantiated
  #
  if "LAB_TFC_HOSTNAME" not in os.environ:
    log("ERROR", "LAB_TFC_HOSTNAME env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got LAB_TFC_HOSTNAME")
    LAB_TFC_HOSTNAME = os.environ.get('LAB_TFC_HOSTNAME')

  if "HCP_CLIENT_ID" not in os.environ:
    log("ERROR", "HCP_CLIENT_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got HCP_CLIENT_ID")
    HCP_CLIENT_ID = os.environ.get('HCP_CLIENT_ID')

  if "HCP_CLIENT_SECRET" not in os.environ:
    log("ERROR", "HCP_CLIENT_SECRET env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got HCP_CLIENT_SECRET")
    HCP_CLIENT_SECRET = os.environ.get('HCP_CLIENT_SECRET')

  if "HCP_PROJECT_ID" not in os.environ:
    log("ERROR", "HCP_PROJECT_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got HCP_PROJECT_ID")
    HCP_PROJECT_ID = os.environ.get('HCP_PROJECT_ID')

  if "HCP_ORGANIZATION_ID" not in os.environ:
    log("ERROR", "HCP_ORGANIZATION_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got HCP_ORGANIZATION_ID")
    HCP_ORGANIZATION_ID = os.environ.get('HCP_ORGANIZATION_ID')

  if "PIPE_HCPP_HMAC" not in os.environ:
    log("ERROR", "PIPE_HCPP_HMAC env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got PIPE_HCPP_HMAC")
    PIPE_HCPP_HMAC = os.environ.get('PIPE_HCPP_HMAC')

  if "GITHUB_TOKEN" not in os.environ:
    log("ERROR", "GITHUB_TOKEN env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got GITHUB_TOKEN")
    GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN')

  ## Doormat dmrf puts these into the a-org-meta workspace
  #
  # if "AWS_ACCESS_KEY_ID" not in os.environ:
  #   log("ERROR", "AWS_ACCESS_KEY_ID env var not instantiated", "main")
  #   exit(1)
  # else:
  #   log("INFO", inspect.currentframe().f_code.co_name, "Got AWS_ACCESS_KEY_ID")
  #   AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')

  # if "AWS_SECRET_ACCESS_KEY" not in os.environ:
  #   log("ERROR", "AWS_SECRET_ACCESS_KEY env var not instantiated", "main")
  #   exit(1)
  # else:
  #   log("INFO", inspect.currentframe().f_code.co_name, "Got AWS_SECRET_ACCESS_KEY")
  #   AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')

  ## Azure credentials for DNS Route53 domain delegation
  #
  if "ARM_TENANT_ID" not in os.environ:
    log("ERROR", "ARM_TENANT_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got ARM_TENANT_ID")
    ARM_TENANT_ID = os.environ.get('ARM_TENANT_ID')

  if "ARM_SUBSCRIPTION_ID" not in os.environ:
    log("ERROR", "AWS_SECRARM_SUBSCRIPTION_IDET_ACCESS_KEY env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got ARM_SUBSCRIPTION_ID")
    ARM_SUBSCRIPTION_ID = os.environ.get('ARM_SUBSCRIPTION_ID')

  if "ARM_CLIENT_ID" not in os.environ:
    log("ERROR", "ARM_CLIENT_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got ARM_CLIENT_ID")
    ARM_CLIENT_ID = os.environ.get('ARM_CLIENT_ID')

  if "ARM_CLIENT_SECRET" not in os.environ:
    log("ERROR", "ARM_CLIENT_SECRET env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got ARM_CLIENT_SECRET")
    ARM_CLIENT_SECRET = os.environ.get('ARM_CLIENT_SECRET')

  ## GCP credentials for DNS delegation
  #
  if "GOOGLE_PROJECT_ID" not in os.environ:
    log("ERROR", "GOOGLE_PROJECT_ID env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got GOOGLE_PROJECT_ID")
    GOOGLE_PROJECT_ID = os.environ.get('GOOGLE_PROJECT_ID')

  # Attempt to read and set GOOGLE_CREDENTIALS from a file
  try:
    credentials_path = os.path.expanduser('~/.gcp/credentials.json')
    with open(credentials_path, 'r') as file:
      credentials = json.load(file)
    credentials_json = json.dumps(credentials)
    os.environ['GOOGLE_CREDENTIALS'] = credentials_json
    log("INFO", inspect.currentframe().f_code.co_name, "Set GOOGLE_CREDENTIALS from file")
  except Exception as e:
    log("ERROR", str(e), inspect.currentframe().f_code.co_name)
    exit(1)

  if "GOOGLE_CREDENTIALS" not in os.environ:
    log("ERROR", "GOOGLE_CREDENTIALS env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got GOOGLE_CREDENTIALS")
    GOOGLE_CREDENTIALS = os.environ.get('GOOGLE_CREDENTIALS')

  ## solicit token from information provided - expect environment variable to be created
  #
  with open(os.path.expanduser("~/.terraform.d/credentials.tfrc.json"), "r") as f:
    data = json.load(f)

  if LAB_TFC_HOSTNAME in data['credentials']:
    # Extract the token from the data
    hcpt_token = data['credentials'][LAB_TFC_HOSTNAME]['token']
    log("INFO", inspect.currentframe().f_code.co_name, "Got HCPT TOKEN")
  else:
    print(f"{LAB_TFC_HOSTNAME} key not found in the JSON data.")
    exit(1)

  ## EARLY PHASE ###############################################################################################################################
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "ENTERPRISE ONLY RUN TASK FOR HCPP")

  if "PIPE_HCPP_HMAC" not in os.environ:
    log("ERROR", inspect.currentframe().f_code.co_name, "PIPE_HCPP_HMAC env var not instantiated")
    return 1

  add_org_run_task(hcp_run_task_name, hcp_run_task_url, os.environ["PIPE_HCPP_HMAC"], hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## global variable sets
  #
  ## Create HCP env varset for hcp provider usage - ENVIRONMENT VARIABLES FOR PROVIDER USE, NOT TERRAFORM VARS AS BELOW
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "GLOBAL VARIABLE SET FOR HCPP HCP PROVIDER ENVIRONMENT")

  varset_id_hcpp_hcp_provider_environment = new_global_variable_set("hcpp_hcp_provider_environment", hcpt_token, LAB_TFC_HOSTNAME)
  print()

  add_variable_to_set(varset_id_hcpp_hcp_provider_environment, "HCP_CLIENT_ID", HCP_CLIENT_ID, False, "env", "HCPP run task/pipe org-level client ID", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  add_variable_to_set(varset_id_hcpp_hcp_provider_environment, "HCP_CLIENT_SECRET", HCP_CLIENT_SECRET, True, "env", "HCPP run task/pipe org-level client secret", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## Create HVS tfvar varset for vlt cli - NOT ENVIRONMENT VARS - TERRAFORM VARS FOR PASSING INTO INFRA FOR SCRIPT ACCESS TO HVS
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "NONGLOBAL VARIABLE SET FOR HCPP HCP VAULT SECRETS VLT CLI USE DURING BUILD FOR SECRET EXTRACTION")
  varset_id_hvs_vlt_cli_tfvars = new_non_global_variable_set("hvs_vlt_cli_tfvars", hcpt_token, LAB_TFC_HOSTNAME)
  print()

  add_variable_to_set(varset_id_hvs_vlt_cli_tfvars, "_HCP_PROJECT_ID", HCP_PROJECT_ID, False, "terraform", "HCP Vault Secrets vlt cli use during build for secret extraction: project ID", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  add_variable_to_set(varset_id_hvs_vlt_cli_tfvars, "_HCP_ORGANIZATION_ID", HCP_ORGANIZATION_ID, False, "terraform", "HCP Vault Secrets vlt cli use during build for secret extraction: client secret", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  add_variable_to_set(varset_id_hvs_vlt_cli_tfvars, "_HCP_CLIENT_ID", HCP_CLIENT_ID, False, "terraform", "HCP Vault Secrets vlt cli use during build for secret extraction: org-level client ID", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  add_variable_to_set(varset_id_hvs_vlt_cli_tfvars, "_HCP_CLIENT_SECRET", HCP_CLIENT_SECRET, True, "terraform", "HCP Vault Secrets vlt cli use during build for secret extraction: org-level client secret", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## Create terraform var licence varset for app deploy
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "NONGLOBAL VARIABLE SET FOR APP LICENCE KEYS FOR APP DEPLOYMENT")
  varset_id_app_licence_keys = new_non_global_variable_set("app_licence_keys", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## now iterate the licence keys and add them to the varset
  #
  for app in ["vault", "consul", "nomad", "terraform"]:
    with open(f'{nightshade}/{app}.hclic', 'r') as file:
      licence = file.read()

    add_variable_to_set(varset_id_app_licence_keys, f"{app}_licence_key", licence, True, "terraform", f"App licence key for {app} app deployment", hcpt_token, LAB_TFC_HOSTNAME)
    print()
  #
  ## Create terraform var TLS varset for app deploy
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "NONGLOBAL VARIABLE SET FOR APP SERVER TLS CERTS AND KEYS FOR APP DEPLOYMENT")
  varset_id_app_tls_certs_keys = new_non_global_variable_set("app_tls_certs_keys", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## now iterate the tls certs and keys and add them to the varset as individual items bearing in mind that there is one pair for each region for vault
  ## NOTE: We are only handling vault here because consul and nomad tls will be based on pki secrets engine
  #
  with open(f'{nightshade}/ca.pem', 'r') as file:
    ca = file.read()
  add_variable_to_set(varset_id_app_tls_certs_keys, f"ca", ca, False, "terraform", f"TLS CA cert for all app deployment", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  # for region in regions:
  #   for pem in ["cert", "key"]:
  #     with open(f'{nightshade}/server.{region}.dev-vault-lab.{domain}.0.{pem}.pem', 'r') as file:
  #       tls = file.read()

  #     add_variable_to_set(varset_id_app_tls_certs_keys, f"{region}_vault_{pem}", tls, True, "terraform", f"TLS {pem} for {region} vault app deployment", hcpt_token, LAB_TFC_HOSTNAME)
  #     print()
  #
  ## EARLY PHASE ###############################################################################################################################

  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "Phase a: organisation - lab project/workspace creation")

  ## setup platform team project - org-level and LZ builder
  #
  project_id = new_project("a-org-meta", hcpt_token, LAB_TFC_HOSTNAME)
  print()
  #
  ## Create top level workspace to do dynamic provider credentials OIDC provider, DNS, agent_pools and other extra-stacks deployment - CANNOT DO THAT WITH STACKS AS THEY NEED AN OIDC PROVIDER IN PLACE FIRST
  #
  workspace_id = new_workspace("a-org-meta", project_id, hcpt_token, LAB_TFC_HOSTNAME)
  print()

  ## THESE 4 ARE NEED TO BE ADDED TO THE STACK THAT DEPLOYS b-lz; THEY WERE IN THE a-org-platform WORKSPACE BUT IT"S NOW A STACK AND I CANNOT DEPLOY VIA API
  new_workspace_variable(workspace_id, "terraform", "hcpt_token", hcpt_token, True, hcpt_token, LAB_TFC_HOSTNAME)
  print()
  ## will be used by the lz module to run the GH api workflow dispatch to personalise the repo created which backs the LZs created.
  #
  new_workspace_variable(workspace_id, "terraform", "gh_token", GITHUB_TOKEN, True, hcpt_token, LAB_TFC_HOSTNAME)
  print()
  new_workspace_variable(workspace_id, "terraform", "hcp_run_task_hmac", PIPE_HCPP_HMAC, True, hcpt_token, LAB_TFC_HOSTNAME)
  print()

  ## CREATE A REPO FOR THE a-org-meta STACK BACKING
  #
  # log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;36mTrying to create GH repo to back the meta stack \033[0m|\033[1;31ma-org-meta-stack\033[0m|")
  # command = ["gh", "repo", "create", "a-org-meta-stack",  "--template", "ml4/terraform-template-stack", "--private" ]
  # try:
  #   result = subprocess.run(command, capture_output=True, text=True, check=True)
  #   log("INFO", inspect.currentframe().f_code.co_name, "Repository created successfully")
  # except subprocess.CalledProcessError as e:
  #   error_message = e.stderr.strip()
  #   if "Name already exists on this account" in error_message:
  #     log("WARN", inspect.currentframe().f_code.co_name, "Repository already exists, skipping creation")
  #   else:
  #     log("ERROR", inspect.currentframe().f_code.co_name, error_message)

  ## Add Azure and GCP credentials
  #
  # new_workspace_variable(workspace_id, "env", "ARM_TENANT_ID", ARM_TENANT_ID, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  # new_workspace_variable(workspace_id, "env", "ARM_SUBSCRIPTION_ID", ARM_SUBSCRIPTION_ID, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  # new_workspace_variable(workspace_id, "env", "ARM_CLIENT_ID", ARM_CLIENT_ID, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  # new_workspace_variable(workspace_id, "env", "ARM_CLIENT_SECRET", ARM_CLIENT_SECRET, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  # new_workspace_variable(workspace_id, "env", "GOOGLE_PROJECT_ID", GOOGLE_PROJECT_ID, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  # new_workspace_variable(workspace_id, "env", "GOOGLE_CREDENTIALS", GOOGLE_CREDENTIALS, False, hcpt_token, LAB_TFC_HOSTNAME)
  # print()

  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "Done")
#
## end main

if __name__ == '__main__':
  main()




