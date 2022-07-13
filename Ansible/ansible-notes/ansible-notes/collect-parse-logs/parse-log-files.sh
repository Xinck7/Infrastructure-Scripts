#!/bin/bash
# Author: Nickolaus Vendel
# Date: 10-25-21
# revision: draft

#Notes: this runs on the box to distribute the parsing on its own path before copying anything to the central node
#This is run on an individual computer to add together the relevant information to complete a total report

# Variables
report_path=/scripts/audits/weekly_report.txt

echo "Starting report" > $report_path
echo "Hostname:" >> $report_path
hostname >> $report_path
echo "IP:" >> $report_path
ifconfig | grep 192.168.10 >> $report_path

# bad login
echo "################################" >> $report_path
echo "#Report for Bad Logins" >> $report_path
echo "################################" >> $report_path
cat /scripts/audits/Archive/unsuccessfulllogins.txt | sort -u >> $report_path
echo "################################" >> $report_path

# password changes
echo "################################" >> $report_path
echo "#Report for Password changes" >> $report_path
echo "################################" >> $report_path
cat /scripts/audits/Archive/passwordactivity.txt >> $report_path
echo "################################" >> $report_path

# failed access
echo "################################" >> $report_path
echo "#Report for failed access" >> $report_path
echo "################################" >> $report_path
cat /scripts/audits/Archive/Weekly_SROs.txt >> $report_path
echo "################################" >> $report_path

# sudo 
echo "################################" >> $report_path
echo "#Report for Sudo" >> $report_path
echo "################################" >> $report_path
cat /scripts/audits/Archive/sulog.txt >> $report_path
echo "################################" >> $report_path

#uvscan results
echo "################################" >> $report_path
echo "#UVscan results (brief)" >> $report_path
grep -v "OK" /scripts/audits/Archive/completeviruscanresults.txt | grep -v "could not be opened" | grep -v "is a broken" | grep -v "is a block" | grep -v "is not supported" >> $report_path
echo "################################" >> $report_path

