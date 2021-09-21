#!/bin/bash
## change to "bin/sh" when necessary

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
# Compare if they're the same
if [[ $ip == $old_ip ]]; then
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
