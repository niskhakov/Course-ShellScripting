#!/bin/bash

# Count the number of failed logins by IP address
# If there are any IPs with over LIMIT features, display the count, IP and location

LIMIT='10'
LOG_FILE="${1}"

if [[ ${#} -ne 1 ]]; then
  echo "Usage: ${0} FILE" >&2
  echo "File is not provided" >&2
  exit 1
fi

if [[ ! -e ${LOG_FILE} ]]; then
  echo "File does not exist or cannot open log file" >&2
  exit 1
fi

# Display the header
echo 'Count,IP,Location'

# Loop through the list of failed attempts and corresponding IP addresses
grep "Failed" $LOG_FILE | awk '{print $(NF - 3)}' | sort | uniq -c | sort -rn| while read COUNT IP
do
  # If the number of failed attempts is greater than the limit, display the count, IP and location
  if [[ "${COUNT}" -gt "${LIMIT}" ]]; then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0




# IP_AND_COUNT=$(grep "Failed" syslog-sample | awk '{print $(NF-3)}' | sort -t '.' -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq -c | awk '$1>10' | sort -n)
# echo "${IP_AND_COUNT}" | while read LINE; do
#   COUNTRY=$(geoiplookup $(echo $LINE | cut -d " " -f 2) | awk -F ", " '{print $(NF)}')
#   echo $LINE | awk -v country="$COUNTRY" -v OFS="," '{print $1, $2, country}'
# done

