#!/bin/bash
## change to "bin/sh" when necessary

## credit for the base script logic goes to https://github.com/K0p1-Git/cloudflare-ddns-updater

## variables
username=""                             # The email used to login 'https://www.dnsomatic.com/'
password=""                             # Your DNS-O-Matic login password
record_name=""                          # Which DNS record you want to be synced

###########################################
## Check if we have a public IP
###########################################
ip=$(curl -s http://myip.dnsomatic.com/)

if [ "${ip}" == "" ]; then 
  echo "DDNS Updater: No public IP found"
  exit 1
fi

###########################################
## Get existing IP
###########################################
# run this if we have a domain/record name to check against
if [[ ! -z $record_name ]]; then
  # check if the dig command exists, if not fall back on nslookup
  digExists=$(command -v dig)
  [[ ! -z $digExists ]] && old_ip=$(dig $record_name +short) || old_ip=$(nslookup $record_name | grep -o -E '([0-9][0-9]?[0-9]?\.?){4}$' | awk 'NR==2')

  # get today's date
  day=$(date +%d)
  # Check if today is the 14th or 28th
  if [[ $day == 14 || $day == 28 ]]; then
    echo "We update DNS-O-Matic today to let them know we're still here."
  # Compare if they're the same
  elif [[ $ip == $old_ip ]]; then
    echo "DDNS Updater: IP ($ip) for ${record_name} has not changed."
    exit 0
  fi
fi

###########################################
## Change the IP@DNS-O-Matic using the API
###########################################
if [ "${old_ip}" == "" ]; then 
  echo "Requesting to update all.dnsomatic.com"
  update=$(curl -s --user-agent "Custom DDNS Updater - 0.1" -u $username:$password "https://updates.dnsomatic.com/nic/update?myip=$ip")
else
  echo "Requesting to update a specific domain, so we're running update.dnsomatic.com"
  update=$(curl -s --user-agent "Custom DDNS Updater - 0.1" -u $username:$password "https://updates.dnsomatic.com/nic/update?hostname=$record_name&wildcard=NOCHG&myip=$ip")
fi

###########################################
## Report the status
###########################################
case "$update" in
  "good $ip")
    echo "DDNS Updater: $ip $record_name DDNS updated."
    exit 0;;
  *)
    echo "DDNS Updater: $ip $record_name DDNS failed. DUMPING RESULTS:"
    echo -e $update
    exit 1;;
esac
