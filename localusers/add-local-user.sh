#!/bin/bash

# Ensure that the user has root privilages (return 1)
ROOT_ID=0
if [[ $UID -ne $ROOT_ID ]]; then
  echo "You can create users only with root privileges"
  exit 1
fi

# Get login
read -p "Enter login: " LOGIN

# Get name
read -p "Enter name: " NAME

# Get password
read -p "Enter password: " PASSWORD

# Create new user using useradd
useradd -c "${NAME}" -m ${LOGIN}

if [[ "${?}" -ne 0 ]]; then
  echo "Error: user was not created, see 'man useradd' with exit status ${?}"
  exit 1
fi

echo $PASSWORD | passwd --stdin ${LOGIN}

if [[ "${?}" -ne 0 ]]; then
  echo 'The password for the account could not be set.'
  exit 1
fi

# Force password change on first login
passwd -e ${LOGIN}

# Show username password and host
echo -e "Credentials: \nLogin: ${LOGIN}\nPassword: ${PASSWORD}\nHostname: ${HOSTNAME}"
exit 0