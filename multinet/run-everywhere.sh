#!/bin/bash

# 
SERVER_FILE="/vagrant/servers"
VERBOSE="false"
DRY="false"
AS_SUDO=""
SSH_OPTS="-o ConnectTimeout=2"

usage() {
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND [COMMAND...]" >&2
  echo "  -n        Dry run, commands will be displayed instead of execution" >&2
  echo "  -s        Run the command with sudo (superuser) privileges on remote servers" >&2
  echo "  -v        Verbose mode" >&2
  echo "  -f FILE   Override default file of servers /vagrant/servers" >&2
}

log() {
  MESSAGE="${1}"
  if [[ "${VERBOSE}" = "true" ]]; then
    echo ${MESSAGE}
  fi
}

if [[ "${UID}" = 0 ]]; then
  echo "Command should be executed without superuser privileges, use option -s instead" >&2
  exit 1
fi

while getopts nsvf: OPTION; do
  case "${OPTION}" in
    n)
      DRY="true"
      ;;
    s)
      AS_SUDO="sudo"
      ;;
    v)
      VERBOSE="true"
      ;;
    f)
      SERVER_FILE="${OPTARG}"
      ;;
    ?)
      usage
      exit 1
  esac
done

shift $((OPTIND - 1))

if [[ "${#}" -lt 1 ]]; then
  usage
  exit 1
fi

if [[ ! -e "${SERVER_FILE}" ]]; then
  echo "File ${SERVER_FILE} does not exist or there are no permissions"
  exit 1
fi

# echo "${@}"
EXIT_CODE='0'

for SERVER in $(cat ${SERVER_FILE}); do
  log "===> Executing commands on ${SERVER}"
  if [[ "${DRY}" = "true" ]]; then
    ssh ${SSH_OPTS} ${SERVER} "echo 'DRY RUN: ${AS_SUDO} ${@}'"
   else 
    ssh ${SSH_OPTS} ${SERVER} "${AS_SUDO} ${@}"
  fi
  EXIT_CODE=${?}
  if [[ ${EXIT_CODE} -ne 0 ]]; then 
    echo "*${SERVER}* Command '${@}' was not successfully finished, exit code ${EXIT_CODE}"
  fi
done

exit $EXIT_CODE


# #!/bin/bash

# # A list of servers, one per line.
# SERVER_LIST='/vagrant/servers'

# # Options for the ssh command.
# SSH_OPTIONS='-o ConnectTimeout=2'

# usage() {
#   # Display the usage and exit.
#   echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
#   echo 'Executes COMMAND as a single command on every server.' >&2
#   echo "  -f FILE  Use FILE for the list of servers. Default: ${SERVER_LIST}." >&2
#   echo '  -n       Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
#   echo '  -s       Execute the COMMAND using sudo on the remote server.' >&2
#   echo '  -v       Verbose mode. Displays the server name before executing COMMAND.' >&2
#   exit 1
# }

# # Make sure the script is not being executed with superuser privileges.
# if [[ "${UID}" -eq 0 ]]
# then
#   echo 'Do not execute this script as root. Use the -s option instead.' >&2
#   usage
# fi

# # Parse the options.
# while getopts f:nsv OPTION
# do
#   case ${OPTION} in
#     f) SERVER_LIST="${OPTARG}" ;;
#     n) DRY_RUN='true' ;;
#     s) SUDO='sudo' ;;
#     v) VERBOSE='true' ;;
#     ?) usage ;;
#   esac
# done

# # Remove the options while leaving the remaining arguments.
# shift "$(( OPTIND - 1 ))"

# # If the user doesn't supply at least one argument, give them help.
# if [[ "${#}" -lt 1 ]]
# then
#   usage
# fi

# # Anything that remains on the command line is to be treated as a single command.
# COMMAND="${@}"

# # Make sure the SERVER_LIST file exists.
# if [[ ! -e "${SERVER_LIST}" ]]
# then
#   echo "Cannot open server list file ${SERVER_LIST}." >&2
#   exit 1
# fi

# # Expect the best, prepare for the worst.
# EXIT_STATUS='0'

# # Loop through the SERVER_LIST
# for SERVER in $(cat ${SERVER_LIST})
# do
#   if [[ "${VERBOSE}" = 'true' ]]
#   then
#     echo "${SERVER}"
#   fi

#   SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"
 
#   # If it's a dry run, don't execute anything, just echo it.
#   if [[ "${DRY_RUN}" = 'true' ]]
#   then
#     echo "DRY RUN: ${SSH_COMMAND}"
#   else
#     ${SSH_COMMAND}
#     SSH_EXIT_STATUS="${?}"

#     # Capture any non-zero exit status from the SSH_COMMAND and report to the user.
#     if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
#     then
#       EXIT_STATUS=${SSH_EXIT_STATUS}
#       echo "Execution on ${SERVER} failed." >&2
#     fi 
#   fi
# done

# exit ${EXIT_STATUS}