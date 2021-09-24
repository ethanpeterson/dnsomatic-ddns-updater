# dnsomatic-ddns-updater
Bash script updates DNS-O-Matic services with a dynamic IP address. Running
this script daily will update your dynamic IP address with DNS-O-Matic if your
IP address changes or it's the 14th or 28th of the month. 

## Requirements
The following is needed to sync your dynamic IP address with DNS-O-Matic:  
* A DNS-O-Matic account <https://www.dnsomatic.com/>
* A dynamic DNS service account setup with DNS-O-Matic. You can find a list of DDNS service providers at <https://dynamic.domains/dynamic-dns/providers-list/default.aspx>
* A way to run this script, preferrably automatically/scheduled

## Getting Started
Download the script and update the _variables_ section with your specific
settings. Setup the script with execute permissions, e.g. sudo chmod+ dnsomatic-ddns-updater<span>.sh 
Typically cron is used to schedule jobs, e.g. once a day

Example crontab set up:  

`$ sudo su `  
`$ crontab -e`  
Then add the script per the below table...  
`# +---------------- minute (0 - 59)`  
`# |  +------------- hour (0 - 23)`  
`# |  |  +---------- day of month (1 - 31)`  
`# |  |  |  +------- month (1 - 12)`  
`# |  |  |  |  +---- day of week (0 - 6) (Sunday=0 or 7)`  
`# |  |  |  |  |`  
`  00 01 *  *  * /bin/bash /opt/myscripts/dnsomatic-ddns-updater.sh `  

Enjoy.

## Contributing

Copyright (c) 2021 @ethanpeterson
