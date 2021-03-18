#!/bin/bash

# Ensure that the user has root privilages (return 1)
ROOT_ID=0
if [[ $UID -ne $ROOT_ID ]]; then
  echo "Run this command with sudo"
  exit 1
fi

# Check if there are no arguments provided
if [[ "${#}" -lt 1 ]]; then
  echo 'No arguments provided'
  echo
  echo "Usage: ${0} USERNAME [COMMENT]"
  echo 'Creates new user with provided username and comment'
  exit 1
fi

USERNAME="${1}"
shift 2
COMMENT="${*}"

# echo $USERNAME
# echo $COMMENT

# Create new user using useradd
useradd -c "${COMMENT}" -m ${USERNAME}

if [[ "${?}" -ne 0 ]]; then
  echo "Error: user was not created, see 'man useradd' with exit status ${?}"
  exit 1
fi

PASSWORD=$(date +%s%N | sha256sum | head -c24)
echo $PASSWORD | passwd --stdin ${USERNAME}

if [[ "${?}" -ne 0 ]]; then
  echo 'The password for the account could not be set.'
  exit 1
fi

# Force password change on first login
passwd -e ${USERNAME}

# Show username password and host
echo -e "Credentials: \nLogin: ${USERNAME}\nPassword: ${PASSWORD}\nHostname: ${HOSTNAME}"
exit 0