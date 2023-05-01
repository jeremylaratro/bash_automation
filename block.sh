#!/bin/bash
# Created by: Jeremy Laratro
# this script is designed to automatically parse a snort alert file and then take any ip addresses that were given priority x (user assigned) and up (1=highest) to
# be blocked with ufw - in and out. I created this script in order to learn more about and increase security after creating a website, securicoder.com, and noticed the amount of malicious traffic. 


## add as a cronjob:
# Examples:
# crontab -e
# Every hour:
# 59 * * * *  /var/lib/block.sh
# Once a day at 23:59:
# 59 23 * * * /var/lib/block.sh


#enter your desired snort logfile path here (ie. snort.alert,etc)
LOGFILE=/var/log/snort.alert.fast.1
PRI=1

# Old method (buggy, failed edge cases)
# ---------------------------
# use grep to grab any priority 1 alerts, then extract both IPv4 and IPv6 and add them to the ufw deny list
#cat $LOGFILE | grep 'Priority: 1' | grep  -Eo -- '->'.[0-9].+.+[0-9] | tr -d -- '->' > priority1.txt
#sed 's/....$//' < priority1.txt > priority1_procd.txt
# --------------------------

# New method:
#---------------------------
# filter the snort alert for priorities up to the given value, then separate by ipv6 and ipv4, drop the port, and then deny with ufw
# ipv4:
for i in {1..$PRI}; do cat $LOGFILE | grep 'Priority: '$i | grep  -Eo -- '->'.[0-9].+.+[0-9] | tr -d -- '->' > priority1.txt | sort -u | grep -v [0-9][0-9][0-9][0-9]: > ipv4.txt; cat ipv4.txt | awk -F':' '{print $1}' > ipv4_p.txt; done
while read line; do sudo ufw deny to $line && sudo ufw deny from $line; done < ipv4_p.txt
# ipv6
for i in {1..$PRI}; do cat $LOGFILE | grep 'Priority: '$i | grep  -Eo -- '->'.[0-9].+.+[0-9] | tr -d -- '->' > priority1.txt | sort -u | grep [0-9][0-9][0-9][0-9]: > ipv6.txt; cat ipv6.txt | sed 's/:[0-9]\+$//'  > ipv6_p.txt; done
while read line; do sudo ufw deny to $line && sudo ufw deny from $line; done < ipv6_p.txt

