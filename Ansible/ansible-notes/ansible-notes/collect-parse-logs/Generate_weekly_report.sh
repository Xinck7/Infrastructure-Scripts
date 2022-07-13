#!/bin/bash

# Author: Nickolaus Vendel
# Date: 10-25-21
# revision: draft

# Variables
collection_path=/ansible-collection/weekly_reports/
total_pcs=$(ls -1 ${collection_path}| wc -l)
final_report_path=/ansible-collection/generated_reports/Final_report_`date '+%y_%m_%d'`.txt
mkdir -p /ansible-collection/generated_reports/
touch $final_report_path

# Run playbook 

#Against tests
ansible-playbook Collect-and-parse-logs.yml -kK -i inventory.ini -l "Security_test_computers"
#to run Against everything comment above and uncomment below
# ansible-playbook Collect-and-parse-logs.yml -K -i inventory.ini -l "SIL_computers"

# Cat all together
# date
date > $final_report_path
# total computers
echo "The total PC's checked $total_pcs" >> $final_report_path
cat /ansible-collection/weekly_reports/*/scripts/audits/weekly_report.txt >> $final_report_path