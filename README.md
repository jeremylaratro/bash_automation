# bash_automation


### block.sh
 >>This script is designed to automatically parse a snort alert file and then take any ip addresses that were given priority x (user assigned) and up (1=highest) to be blocked with ufw - in and out. I created this script in order to learn more about and increase security after creating a website, securicoder.com, and noticed the amount of malicious traffic. 


### Add as a cronjob:
 Examples:
 ```
 chmod +x block.sh; crontab -e
 ```
 Every hour:
 ```
 59 * * * *  /var/lib/block.sh
 ```
 
 Once a day at 23:59:
```
59 23 * * * /var/lib/block.sh
```
