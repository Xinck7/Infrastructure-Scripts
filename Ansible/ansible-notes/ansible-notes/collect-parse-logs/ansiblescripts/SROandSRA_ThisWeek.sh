#!/bin/bash

#provided by Security Boss

#Edits made by Nickolaus Vendel
## adjusted redirects
## added comments
## grouped by function
## adjusted logic to be able to run manually
## fixed hanging commands
## fixed uvscan to actually run a scan which takes forever

#Create file paths and copy files over
mkdir -p /scripts/audits/Archive/
mkdir -p /var/log/audit/Archive/
cp ./last8days /scripts
cp ./SROandSRA_ThisWeek.sh /scripts

#Ausearches for -k's
/sbin/ausearch -i -ts week-ago -k time-change --success yes > /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k time-change --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k logins --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k delete --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k system-locale --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
# /sbin/ausearch -i -ts week-ago -k open --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k mods --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k creation --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k system-locale --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k audit-logs --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k auth --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k mykey --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts week-ago -k account_changes --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
# /sbin/ausearch -i -ts week-ago -k account_changes --success yes >> /scripts/audits/Archive/Weekly_SRAs.txt

#Ausearches for recent
/sbin/ausearch -i -ts recent -k time-change --success no >> /scripts/audits/Archive/Weekly_SRAs.txt
/sbin/ausearch -i -ts recent -k time-change --success yes >> /scripts/audits/Archive/Weekly_SRAs.txt

#Ausearches for paths
/sbin/ausearch -i -ts week-ago --success no -f /etc/sysconfig/network > /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/faillog >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/lastlog >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/btmp >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/utmp >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/group >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/passwd >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/gshadow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/shadow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/security/opasswd >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/audit/audit.rules >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/audit/auditd.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/resolv.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sudoers >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/messages >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/secure >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/audit/audit.log >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/crontab >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/syslog.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/logrotate.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/wtmp >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /var/log/lastlog >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/ftpusers >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/passwd >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/shadow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/pam.d/password-auth >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/pam.d/system-auth >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/hosts.deny >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/hosts >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/lilo.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/securetty >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/shutdown.allow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/security >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/rc.d/init.d >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/init.d >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sysconfig >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/inetd.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/cron.allow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/cron.deny >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/ssh_config >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sshd_config >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sysctl.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/pam.d/system-auth >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/pam.d/password-auth >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/group >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sysconfig/network/ifcfg-eth0 >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/audit/audit.rules >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/audit/auditd.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/logrotate.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/login.defs >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/grub.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/issue >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/motd >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/sysctl.conf >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/host.allow >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/host.deny >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago --success no -f /etc/syslog.conf >> /scripts/audits/Archive/Weekly_SROs.txt

#Ausearch week ago
/sbin/ausearch -i -ts week-ago -k system-locale --success no >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago -k logins --success no >> /scripts/audits/Archive/Weekly_SROs.txt
/sbin/ausearch -i -ts week-ago -k auth --success no >> /scripts/audits/Archive/Weekly_SROs.txt

#logins
# last -n 100 > /scripts/audits/Archive/successfulllogins.txt
lastb -n 50 > /scripts/audits/Archive/unsuccessfulllogins.txt

#password
grep -i chauthtok /var/log/secure > /scripts/audits/Archive/passwordactivity.txt

#last8days
/scripts/last8days > /scripts/audits/Archive/secure.txt

#sulog
grep 'su:' /var/log/secure > /scripts/audits/Archive/sulog.txt

#accounts locked
grep 'Consecutive login failures' /var/log/secure > /scripts/audits/Archive/accountslocked.txt
grep 'pam_faillock(login:auth)' /var/log/secure >> /scripts/audits/Archive/accountslocked.txt

#USB Devices
# grep 'Mass Storage device' /var/log/messages > /scripts/audits/Archive/USB_Devices.txt
# grep 'Initializing USB Mass Storage driver' /var/log/messages >> /scripts/audits/Archive/USB_Devices.txt

#New USB Devices
# grep -i 'usb-storage\|Mass' /var/log/messages > /scripts/audits/Archive/New_USB_Devices.txt
# grep -i usb_stor_ /var/log/messages >> /scripts/audits/Archive/New_USB_Devices.txt
# dmesg -H | grep -i 'Mass' >> /scripts/audits/Archive/New_USB_Devices.txt

#Unlock accounts
/sbin/ausearch -i --executable faillock >> /scripts/audits/Archive/UnlockAccount.txt
/sbin/ausearch -i --executable /usr/sbin/pam_tally2 >> /scripts/audits/Archive/UnlockAccount.txt

#Account activity
/sbin/ausearch -i -m USER_MGMT >> /scripts/audits/Archive/AccountActivity.txt

#ausearch usermanagement
/sbin/ausearch -i -m USER_MGMT > /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m GRP_MGMT >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m ADD_USER >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m DEL_USER >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m ADD_GROUP >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m USER_CHAUTHTOK >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m DEL_GROUP >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m CHGRP_ID >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m ROLE_ASSIGN >> /scripts/audits/Archive/User_Management.txt
/sbin/ausearch -i -m ROLE_REMOVE >> /scripts/audits/Archive/User_Management.txt

#check wireless devices
# grep -i 'wlan\|WLAN\|radio\|802.11\|ieee80211\|wireless\|RF Kill Switch' /var/log/messages > /scripts/audits/Archive/Wireless_Devices.txt
# dmesg -H | grep -i 'wlan\|wireless' >> /scripts/audits/Archive/Wireless_Devices.txt
# grep wireless /var/log/messages >> /scripts/audits/Archive/Wireless_Devices.txt

#locked accounts
/sbin/pam_tally2 >> /scripts/audits/Archive/accountslocked.txt

#unlock account
grep 'op=faillock-reset' /var/log/audit/audit.log >> /scripts/audits/Archive/UnlockAccount.txt

#Copy to archive location
# cp /var/log/messages /var/log/audit/Archive/messages_`date '+%y_%m_%d'`
# cp /var/log/secure /var/log/audit/Archive/secure_`date '+%y_%m_%d'`
# cp /var/log/syslog /var/log/audit/Archive/syslog_`date '+%y_%m_%d'`
# cp /var/log/audit/audit.log /var/log/audit/Archive/audit.log_`date '+%y_%m_%d'`

#Virus scanning results
date >> /scripts/audits/Archive/viruscanresults.txt > /scripts/audits/Archive/completeviruscanresults.txt
grep Infected /scripts/audits/Archive/viruscanresults.txt >> /scripts/audits/Archive/completeviruscanresults.txt
grep 'Dat set' /scripts/audits/Archive/viruscanresults.txt >> /scripts/audits/Archive/completeviruscanresults.txt
grep 'EST 2021' /scripts/audits/Archive/viruscanresults.txt >> /scripts/audits/Archive/completeviruscanresults.txt
echo "######################" >> /scripts/audits/Archive/completeviruscanresults.txt
echo "Full UV scan below" >> /scripts/audits/Archive/completeviruscanresults.txt
echo "######################" >> /scripts/audits/Archive/completeviruscanresults.txt
cat /scripts/audits/Archive/viruscanresults.txt  >> /scripts/audits/Archive/completeviruscanresults.txt

# tail /scripts/SROandSRA_ThisWeek.sh

#View Results
#gedit /scripts/audits/Archive/*.txt
