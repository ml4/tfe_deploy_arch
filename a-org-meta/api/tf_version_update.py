#!/usr/bin/env python3
#
## tf_version_update.py
## 2024:01:19::@ml4
## Initialize the pipe - tfc api - expects owners users/team API token; does not expect pages of workspaces etc.
#
###############################################################################################################################################

## Imports
#
import datetime
import getopt
import inspect
import json
import os
import subprocess
import sys
import re
import requests
import time

## Globals
#
api_response = ''
SCRIPT_NAME  = os.path.basename(__file__)
tfe_org      = 'ml4'


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
  txtrst = '\033[0m'    # Text Reset

  if level == "INFO":
    COL = bldgrn
  elif level == "ERROR":
    COL = bldred
  elif level == "WARN":
    COL = bldylw

  timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S %Z')
  print(f'{bldcyn}{timestamp}{txtrst} [{COL}{level}{txtrst}] [{SCRIPT_NAME}:{func}] {message}', file=sys.stderr)

###############################################################################################################################################
#
def run_request(hcpt_token, url, payload, type):
  headers = {
    "Authorization": f"Bearer {hcpt_token}",
    "Content-Type": "application/vnd.api+json",
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;34mRequesting {url}\033[0m")
  if type == "get":
    log("WARN", inspect.currentframe().f_code.co_name, f"REQUESTS CALL: URL: {url} payload: {json.dumps(payload).encode('utf-8')}")
    r = requests.get(url, headers=headers, data=json.dumps(payload).encode("utf-8"))
  elif type == "post":
    log("WARN", inspect.currentframe().f_code.co_name, f"REQUESTS CALL: URL: {url} payload: {json.dumps(payload).encode('utf-8')}")
    r = requests.post(url, headers=headers, data=json.dumps(payload).encode("utf-8"))
  elif type == "patch":
    log("WARN", inspect.currentframe().f_code.co_name, f"REQUESTS CALL: URL: {url} payload: {json.dumps(payload).encode('utf-8')}")
    r = requests.patch(url, headers=headers, data=json.dumps(payload).encode("utf-8"))

  if r.status_code > 399 and r.status_code != 422:
    log("ERROR", inspect.currentframe().f_code.co_name, f"\033[1;31m{r.status_code}: Failure code returned.")
    log("ERROR", inspect.currentframe().f_code.co_name, f"text: {r.text}")
    exit(r.status_code)
  elif r.status_code == 422:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;33m{r.status_code}: Requested item already exists.")
    log("WARN", inspect.currentframe().f_code.co_name, f"text: {r.text}")
    return(r)
  elif r.status_code == 200:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;32m{r.status_code}: OK.")
    return(r)
  elif r.status_code == 201:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;32m{r.status_code}: Requested item created OK.")
    return(r)
  elif r.status_code == 204:
    log("INFO", inspect.currentframe().f_code.co_name, f"\033[1;32m{r.status_code}: OK.")
    return(r)
  else:
    log("ERROR", inspect.currentframe().f_code.co_name, f"\033[1;31m{r.status_code}: Requested failed")
    exit(r.status_code)

###############################################################################################################################################
#
def update_workspace_tf_version(workspace_name, terraform_version, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/workspaces/{workspace_name}"
  payload = {
    "data": {
      "attributes": {
        "name": workspace_name,
        "terraform_version": terraform_version,
      },
      "type": "workspaces"
    }
  }

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting change to terraform version in workspace |\033[1;36m{workspace_name}\033[0m|")
  r = run_request(hcpt_token, url, payload, "patch")
  data = json.loads(r.text)

  ## compare the terraform_version returned from the API call with the passed version in the function call and error if not the same
  #
  if data["data"]["attributes"]["terraform-version"] != terraform_version:
    log("ERROR", inspect.currentframe().f_code.co_name, f"terraform version not updated in workspace |\033[1;32m{workspace_name}\033[0m|")
    exit(1)

###############################################################################################################################################
# list workspaces in an organization
#
def return_workspace_list(hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/workspaces"
  payload = { "data": { "type": "workspaces" } }

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting list of workspaces in |{tfe_org}|")
  r = run_request(hcpt_token, url, payload, "get")
  data = json.loads(r.text)

  ## filter returned data for just the names of the workspaces beginning with b-lz
  #
  workspace_list = []
  for attr in data["data"]:
    if attr["attributes"]["name"].startswith("b-lz"):
      workspace_list.append(attr["attributes"]["name"])

  ## handle situation where workspace list is null and log accordingly
  #
  if len(workspace_list) == 0:
    log("ERROR", inspect.currentframe().f_code.co_name, f"No workspaces returned from |{tfe_org}|")
    exit(1)

  return(workspace_list)

###############################################################################################################################################
## get a workspace ID from a workspace name
#
def return_workspace_id(workspace_name, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/organizations/{tfe_org}/workspaces/{workspace_name}"
  payload = { "data": { "type": "workspaces" } }

  log("INFO", inspect.currentframe().f_code.co_name, f"Requesting workspace ID for |\033[1;36m{workspace_name}\033[0m|")
  r = run_request(hcpt_token, url, payload, "get")
  data = json.loads(r.text)

  ## check that the workspace exists and log accordingly
  #
  if "errors" in data:
    log("ERROR", inspect.currentframe().f_code.co_name, f"Workspace |\033[1;36m{workspace_name}\033[0m| not found")
    exit(1)

  return(data["data"]["id"])

###############################################################################################################################################
# trigger apply run on workspace
#
def trigger_apply_run(workspace_id, hcpt_token, LAB_TFC_HOSTNAME):
  url = f"https://{LAB_TFC_HOSTNAME}/api/v2/runs"
  payload = {
    "data": {
      "attributes": {
        "message": "Triggered by tf_version_update.py script",
        "is-destroy": False,
        "is-confirm": True
      },
      "relationships": {
        "workspace": {
          "data": {
            "id": workspace_id,
            "type": "workspaces"
          }
        }
      },
      "type": "runs"
    }
  }

  draw_line("green")
  log("INFO", inspect.currentframe().f_code.co_name, f"Triggering apply run on workspace |\033[1;35m{workspace_id}\033[0m|")
  r = run_request(hcpt_token, url, payload, "post")
  if r.status_code == 422:
    log("WARN", inspect.currentframe().f_code.co_name, "Configuration version is missing for workspace id: " + workspace_id)
    return
  data = json.loads(r.text)
  if "data" in data and "attributes" in data["data"] and "status" in data["data"]["attributes"]:
    if data["data"]["attributes"]["status"] == "pending":
      # rest of the code
      pass
  else:
    log("WARN", inspect.currentframe().f_code.co_name, "Unexpected response structure from API for workspace id: " + workspace_id)

  ## check that the run succeeded and log accordingly - if the status is equal to pending then use a wild loop to wait for the run to complete
  ## for each iteration of the while loop, the status of the run is checked and if it is applied then the loop is broken.
  ## each iteration of the loop must wait five seconds before checking the status of the run again.
  ## report properly if the workspace run fails for any reason
  #
  if data["data"]["attributes"]["status"] == "pending":
    run_id = data["data"]["id"]
    log("INFO", inspect.currentframe().f_code.co_name, f"Run |\033[1;35m{run_id}\033[0m| triggered on workspace |\033[1;35m{workspace_id}\033[0m|")
    while True:
      url = f"https://{LAB_TFC_HOSTNAME}/api/v2/runs/{run_id}"
      payload = { "data": { "type": "runs" } }
      r = run_request(hcpt_token, url, payload, "get")
      data = json.loads(r.text)
      status = data["data"]["attributes"]["status"]
      if status == "applied":
        log("INFO", inspect.currentframe().f_code.co_name, f"Run |\033[1;35m{run_id}\033[0m| applied on workspace |\033[1;35m{workspace_id}\033[0m|")
        break
      elif status == "planned_and_finished":
        log("INFO", inspect.currentframe().f_code.co_name, f"Run |\033[1;35m{run_id}\033[0m| planned and finished on workspace |\033[1;35m{workspace_id}\033[0m|. No apply required.")
        break
      else:
        log("INFO", inspect.currentframe().f_code.co_name, f"Run |\033[1;35m{run_id}\033[0m| status is |\033[1;31m{status}\033[0m|")
      time.sleep(5)  # Wait for 5 seconds


###############################################################################################################################################
## print_usage
#
def print_usage():
  print("Usage: python tf_version_update.py [options]")
  print("Options:")
  print("  --version, -v    Specify the version number")
  print("  --help, -h       Show this help message")


###############################################################################################################################################
## main
#
def main():
  # Parse command line arguments
  try:
    opts, args = getopt.getopt(sys.argv[1:], "hv:", ["help", "version="])
  except getopt.GetoptError:
    print_usage()
    sys.exit(2)

  for opt, arg in opts:
    if opt in ("-h", "--help"):
      print_usage()
      sys.exit()
    elif opt in ("-v", "--version"):
      tf_version = arg
      log("INFO", inspect.currentframe().f_code.co_name, f"Got tf version |\033[1;32m{tf_version}\033[0m|")

  # If no version is provided, print usage and exit
  if 'tf_version' not in locals():
    print_usage()
    sys.exit(2)

  ## source API token
  #
  credentials_file = os.path.join(os.environ["HOME"], ".terraform.d/credentials.tfrc.json")
  if not os.path.isfile(credentials_file):
    log("ERROR", inspect.currentframe().f_code.co_name, "No ~/.terraform.d/credentials.tfrc.json")
    return 1

  ## ensure critical environment variables are instantiated
  #
  if "LAB_TFC_HOSTNAME" not in os.environ:
    log("ERROR", "LAB_TFC_HOSTNAME env var not instantiated", "main")
    exit(1)
  else:
    log("INFO", inspect.currentframe().f_code.co_name, "Got LAB_TFC_HOSTNAME")
    LAB_TFC_HOSTNAME = os.environ.get('LAB_TFC_HOSTNAME')

  ## solicit token from information provided - expect environment variable to be created
  #
  with open(os.path.expanduser("~/.terraform.d/credentials.tfrc.json"), "r") as f:
    data = json.load(f)

  if LAB_TFC_HOSTNAME in data['credentials']:
    # Extract the token from the data
    hcpt_token = data['credentials'][LAB_TFC_HOSTNAME]['token']
    log("INFO", inspect.currentframe().f_code.co_name, "Got TOKEN")
  else:
    print(f"{LAB_TFC_HOSTNAME} key not found in the JSON data.")

  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "Updating LZ workspace tf version to latest")

  ## get list of workspaces in organization
  #
  workspace_list = return_workspace_list(hcpt_token, LAB_TFC_HOSTNAME)

  ## iterate through list of workspaces and update tf version
  #
  for workspace in workspace_list:
    update_workspace_tf_version(workspace, tf_version, hcpt_token, LAB_TFC_HOSTNAME)

  ## as these workspaces are LZ workspaces, trigger apply runs on them in order to ensure that the subordinate workspaces that they create are also updated
  ## NOTE: this is not desired in every situation, but perhaps a Platform Team may need to enforce this in order to ensure that all workspaces are updated in the event of a zero day
  ## in Terraform or similar.
  ## Normally, this step would instead perhaps be an automated notice to the app teams who live in the landing zones, notifying them that they need to update their workspaces at their earliest convenience.
  #
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "Triggering apply runs on LZ workspaces")
  for workspace in sorted(workspace_list):
    workspace_id = return_workspace_id(workspace, hcpt_token, LAB_TFC_HOSTNAME)
    log("INFO", inspect.currentframe().f_code.co_name, f"Triggering apply run on workspace |\033[1;35m{workspace_id}\033[0m (\033[1;36m{workspace}\033[0m)|")
    trigger_apply_run(workspace_id, hcpt_token, LAB_TFC_HOSTNAME)

  print()
  draw_line("purple")
  log("INFO", inspect.currentframe().f_code.co_name, "Done")
  # EARLY PHASE ###############################################################################################################################
#
## end main

if __name__ == '__main__':
  main()




