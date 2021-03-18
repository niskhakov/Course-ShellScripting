#!/bin/bash

# This script creates a new user on the local system
# You must supply a username as an argument to the script
# Optionally, you can also provide a comment for the account as an argument
# A password will be automatically generated for the account
# The username, password and host for the account will be displayed

# Ensure that the user has root privilages (return 1)
ROOT_ID=0
if [[ $UID -ne $ROOT_ID ]]; then
  echo "Run this command with sudo" >&2
  exit 1
fi

# Check if there are no arguments provided
if [[ "${#}" -lt 1 ]]; then
  echo 'No arguments provided' >&2
  echo "Usage: ${0} USERNAME [COMMENT]" >&2
  echo 'Creates new user with provided username and comment' >&2
  exit 1
fi

USERNAME="${1}"
shift 2
COMMENT="${*}"

# echo $USERNAME
# echo $COMMENT

# Create new user using useradd
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null

if [[ "${?}" -ne 0 ]]; then
  echo "Error: user was not created, see 'man useradd' with exit status ${?}" >&2
  exit 1
fi

PASSWORD=$(date +%s%N | sha256sum | head -c24)
echo $PASSWORD | passwd --stdin ${USERNAME} &> /dev/null

if [[ "${?}" -ne 0 ]]; then
  echo 'The password for the account could not be set.' >&2
  exit 1
fi

# Force password change on first login
passwd -e ${USERNAME} &> /dev/null

# Show username password and host
echo -e "Credentials: \nLogin: ${USERNAME}\nPassword: ${PASSWORD}\nHostname: ${HOSTNAME}"
exit 0