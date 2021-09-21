#!/bin/bash
## change to "bin/sh" when necessary

## credit for the base script logic goes to https://github.com/K0p1-Git/cloudflare-ddns-updater

username=""                             # The email used to login 'https://www.dnsomatic.com/'
password=""                             # Your DnsOmatic login password
record_name=""                          # Which DNS record you want to be synced

###########################################
## Check if we have a public IP
###########################################
ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com/)

if [ "${ip}" == "" ]; then 
  echo "DDNS Updater: No public IP found"
  exit 1
fi

###########################################
## Get existing IP
###########################################
old_ip=$(dig $record_name +short)
now=$(date)
day=$($now + %d)
# Check if today is the 14th or 28th
if [[ $day == 14 || $day == 28 ]]; then
  echo "We update DnsOmatic today to let them know we're still here."
# Compare if they're the same
elif [[ $ip == $old_ip ]]; then
  echo "DDNS Updater: IP ($ip) for ${record_name} has not changed."
  exit 0
fi

###########################################
## Change the IP@DnsOMatic using the API
###########################################
update=$(curl -s -u $username:$password "https://updates.dnsomatic.com/nic/update?hostname=$record_name&wildcard=NOCHG&myip=$ip")

###########################################
## Report the status
###########################################
case "$update" in
  "good $ip")
    echo "DDNS Updater: $ip $record_name DDNS updated."
    exit 0;;
  *)
    echo -e "DDNS Updater: $ip $record_name DDNS failed. DUMPING RESULTS:\n$update"
    exit 1;;
esac
