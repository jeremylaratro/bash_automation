#!/bin/bash
#enter your desired snort logfile path here (ie. snort.log, snort.alert,etc)
LOGFILE=/var/log/snort.alert
# use grep to grab any priority 1 alerts, then extract both IPv4 and IPv6 and add them to the ufw deny list
cat /var/log/snort/snort.alert.fast.1 | grep 'Priority: 1' | grep  -Eo -- '->'.[0-9].+.+[0-9] | tr -d -- '->' > pri1.txt
sed 's/....$//' < priority1.txt > priority1_procd.txt
while read line; do sudo ufw deny to $line && sudo ufw deny from $line; done < priority1_procd.txt

