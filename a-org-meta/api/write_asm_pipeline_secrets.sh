#!/bin/bash
#
## write_asm_pipeline_secrets.sh
#
## ml4
## Send hashicorp app licences, CA certificate, service certificate and private key to AWS Secret Manager
## WARNING: Password protect your private key and keep the key offline.
#
##############################################################################################################

readonly SCRIPT_NAME="$(basename "${0}")"
readonly secretsDir="${HOME}/Keep/nightshade"
bldred="\033[1;31m" # Red
bldgrn="\033[1;32m" # Green
bldylw="\033[1;33m" # Yellow
bldblu="\033[1;34m" # Blue
bldpur="\033[1;35m" # Purple
bldcyn="\033[1;36m" # Cyan
bldwht="\033[1;37m" # White
txtrst="\033[0m"    # Text Reset

function usage {
  echo
  echo "usage: $(basename ${0}) <secretsDir> "
  echo -e "\twhere <secretsDir> is your directory with the service certificates and keys in"
  echo -e "\tExpects to see `fullchain.crt` in ."
  echo
  exit 1
}

function log {
  local -r level="$1"
  if [ "${level}" == "INFO" ]
  then
    COL=${bldgrn}
  elif [ "${level}" == "ERROR" ]
  then
    COL=${bldred}
  elif [ "${level}" == "DIVIDE" ]
  then
    COL=${bldpur}
  elif [ "${level}" == "WARN" ]
  then
    COL=${bldylw}
  fi

  local -r func="$2"
  local -r message="$3"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${bldcyn}${timestamp}${txtrst} [${COL}${level}${txtrst}] [${SCRIPT_NAME}:${func}] ${message}"
}

#    #   ##   # #    #
##  ##  #  #  # ##   #
# ## # #    # # # #  #
#    # ###### # #  # #
#    # #    # # #   ##
#    # #    # # #    #

## main
#
function main {
  ## prompt for whether dmrf has been run and press any key to continue
  #
  read -p "Have you run dmrf? If so, press any key to continue..."

  ## Depend on local and fixed structure for finding the relevant credentials - Populate array
  ## Gather the fqdns without the iteratively separate certificates.  Populate ASM secrets with sets of at least one server cert
  #
  array=($(/bin/ls -1 ${secretsDir} | egrep "server.*pem|ca.pem|hclic"))

  ## Detect empty
  #
  if [[ ${#array[@]} -eq 0 ]]
  then
    log "ERROR" "${FUNCNAME[0]}" "No secrets found."
    exit 1
  fi

  for secret in "${array[@]}"
  do
    ## we have licences, ca.pem and a bunch of Vault cert/keys. Iterate in that order first two first
    ## licences/ca.pem
    #
    if [[ ${secret} == *"hclic"* || ${secret} == "ca.pem" ]]
    then
      log "INFO" "${FUNCNAME[0]}" "Processing ${secret}"
      payload=$(cat ${secretsDir}/${secret})
      log "INFO" "${FUNCNAME[0]}" "Secret: ${secret}"
      log "INFO" "${FUNCNAME[0]}" "Secret length: ${#payload}"
      log "INFO" "${FUNCNAME[0]}" "Secret truncated: ${payload:0:20} [... truncated data]"

      ## This puts the payload in ASM in each region
      #
      for region in $(grep -v ^# ${HOME}/.aws_regions | cut -d, -f1)
      do
        log "INFO" "${FUNCNAME[0]}" "REGION: |${bldpur}${region}${txtrst}|"
        ## test if there is a file there already
        #
        aws secretsmanager get-secret-value --region ${region} --secret-id ${secret} > /dev/null
        rCode=${?}
        if [[ ${rCode} == 0 ]]
        then
          log "WARN" "${FUNCNAME[0]}" "Secret |${secret}| already exists. Overwriting..."
          aws secretsmanager update-secret --region ${region} --secret-id ${secret} --secret-string "${payload}" > /dev/null
          rCode=${?}
          if [[ ${rCode} > 0 ]]
          then
            log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager update-secret --region ${region} --secret-id ${secret} --secret-string ${payload:0:12} [... truncated data]"
            exit ${rCode}
          fi
        elif [[ ${rCode} == 254 ]]
        then
          log "INFO" "${FUNCNAME[0]}" "Secret |${secret}| does not exist. Creating..."
          aws secretsmanager create-secret --region ${region} --name ${secret} --description ${secret} --secret-string "${payload}" > /dev/null
          rCode=${?}
          if [[ ${rCode} > 0 ]]
          then
            log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager create-secret --region ${region} --name ${secret} --description ${secret} --secret-string ${payload:0:12} [... truncated data]"
            exit ${rCode}
          fi
        else
          log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager get-secret-value --region ${region} --secret-id ${secret}"
          exit ${rCode}
        fi
      done
    fi
    #
    ## server cert/key pairs - for these, extract the region and direct the files to the correct region
    #
    if [[ ${secret} == *"server"* ]]
    then
      region=$(echo ${secret} | cut -d"." -f2)
      if [[ -z ${region} ]]
      then
        log "ERROR" "${FUNCNAME[0]}" "Region not found in filename |${secret}|"
        exit 1
      fi
      log "INFO" "${FUNCNAME[0]}" "Processing ${secret}"
      payload=$(cat ${secretsDir}/${secret})
      log "INFO" "${FUNCNAME[0]}" "Secret: ${secret}"
      log "INFO" "${FUNCNAME[0]}" "Secret length: ${#payload}"
      log "INFO" "${FUNCNAME[0]}" "Secret truncated: ${payload:0:20} [... truncated data]"

      ## test if there is a file there already
      #
      aws secretsmanager get-secret-value --region ${region} --secret-id ${secret} > /dev/null
      rCode=${?}
      if [[ ${rCode} == 0 ]]
      then
        log "WARN" "${FUNCNAME[0]}" "Secret |${secret}| already exists. Overwriting..."
        aws secretsmanager update-secret --region ${region} --secret-id ${secret} --secret-string "${payload}" > /dev/null
        rCode=${?}
        if [[ ${rCode} > 0 ]]
        then
          log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager update-secret --region ${region} --secret-id ${secret} --secret-string ${payload:0:12} [... truncated data]"
          exit ${rCode}
        fi
      elif [[ ${rCode} == 254 ]]
      then
        log "INFO" "${FUNCNAME[0]}" "Secret |${secret}| does not exist. Creating..."
        aws secretsmanager create-secret --region ${region} --name ${secret} --description ${secret} --secret-string "${payload}" > /dev/null
        rCode=${?}
        if [[ ${rCode} > 0 ]]
        then
          log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager create-secret --region ${region} --name ${secret} --description ${secret} --secret-string ${payload:0:12} [... truncated data]"
          exit ${rCode}
        fi
      else
        log "ERROR" "${FUNCNAME[0]}" "Return status greater than zero for command: aws secretsmanager get-secret-value --region ${region} --secret-id ${secret}"
        exit ${rCode}
      fi
    fi
  done

  log "INFO" "${FUNCNAME[0]}" "All done."
}

main "$@"
#
## jah
