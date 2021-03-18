#!/bin/bash


# This script disables, deletes, and/or archives users on the local system

readonly ARCHIVE_DIR="/archive/"

# Disable account by default
PERFORM="disable"

usage() {
  logerr "Usage: ${0} [-dra] USERNAME [USERNAME...]"
  logerr "Disable user account"
  logerr '  -d  Deletes account instead of disabling'
  logerr '  -r  Removes home dir of user'
  logerr '  -a  Create archive of the home dir'
  exit 1
}

logerr() {
  MESSAGE="${1}"
  echo "${MESSAGE}" >&2
  return 0
}

delete_user() {
  # Perform deletion of user with home dir or without, provides correct output
  local USERNAME="${1}"
  local REMOVE_DIR="${2}"
  if [[ "${REMOVE_DIR}" = 'true' ]]; then

    userdel -r "${USERNAME}"

    if [[ "${?}" -ne 0 ]]; then
      logerr "User was not deleted, see ${?} exit status of userdel command"
      return 1
    else
      echo "User ${USERNAME} and his home dir were deleted"
    fi

  else

    userdel "${USERNAME}"

    if [[ "${?}" -ne 0 ]]; then
      logerr "User was not deleted, see ${?} exit status of userdel command"
      return 1
    else
      echo "User ${USERNAME} was deleted"
    fi

  fi
}

perform_actions() {
  # Incapsulates main program logic: creates archive, disables/deletes user, do some checks
  # GLOBAL VARS used: PERFORM, IS_REMOVE_HOME_DIR, IS_CREATE_ARCHIVE
  USERNAME="${1}"
  USERID=$(id -u "${USERNAME}")

  if [[ "${?}" -ne 0 ]]; then
    echo 
    logerr "User ${USERNAME} does not exist"
    return 1
  fi

  # Refuse to delete the account that have UID -lt 1000
  if [[ "${USERID}" -lt 1000 ]]; then
    logerr "Provided username corresponds to system account, you cannot perform actions on it"
    logerr "Please contact the administrator"
    return 1
  fi

  # Archiving part
  if [[ "${IS_CREATE_ARCHIVE}" = 'true' ]]; then

    if [[ ! -d ${ARCHIVE_DIR} ]]; then # if dir doesnt exists
      echo "Creating ${ARCHIVE_DIR} directory"
      mkdir -p "${ARCHIVE_DIR}"
      if [[ "${?}" -ne 0 ]]; then
        logerr "The archive directory ${ARCHIVE_DIR} could not be created"
        exit 1
      fi
    fi

    local USERFILE="${ARCHIVE_DIR}/${USERNAME}.$(date +%F-%N).tar.gz"
    local USERDIR="/home/${USERNAME}"

    if [[ -d "${USERDIR}" ]]; then 
      echo "Archiving ${USERDIR} to ${USERFILE}"
      tar -zcpf ${USERFILE} ${USERDIR} &> /dev/null    

      if [[ "${?}" -ne 0 ]]; then
        logerr "Archive for ${USERNAME} was NOT created"
        exit 1
      else
        echo "Archive of user ${USERNAME} was placed to ${USERFILE}"
      fi
    fi 
  fi

  # Deleting/Disabling account
  case "${PERFORM}" in
  disable)
    chage -E 0 "${USERNAME}"

    if [[ "${?}" -ne 0 ]]; then
      logerr "User ${USERNAME} was not disabled, see ${?} exit status of chage command"
      return 1
    else
      echo "User ${USERNAME} was disabled"
    fi
    ;;
  delete)
    delete_user "${USERNAME}" "${IS_REMOVE_HOME_DIR}"
    ;;
  esac

  return 0
}

############################ STARTING POINT ############################

# Enforce to run as sudo
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run as sudo or as root'
  exit 1
fi

while getopts dra OPTION; do
  case "${OPTION}" in
  d)
    PERFORM='delete'
    ;;
  r)
    IS_REMOVE_HOME_DIR='true'
    ;;
  a)
    IS_CREATE_ARCHIVE='true'
    ;;
  ?)
    usage
    ;;
  esac
done

# Remove the options while leaving the remaining arguments
shift $((OPTIND - 1))

# Accept a list of usernames as args, at least one required, else usage
# Provide usage statement if theres no account name
if [[ "${#}" -lt 1 ]]; then
  logerr 'No username specified, at least one required'
  logerr
  usage
fi

# Main processing
for USERNAME in "${@}"; do
  perform_actions "${USERNAME}"
done

exit 0