#!/bin/bash
#author Nickolaus Vendel
#date 7-20-21
#rev 1

#vars
log_path="/var/log/perfmon.txt"
exec_sum_log_path="/var/log/quick-check-perfmon.txt"
days_to_keep_log=5

#Raw output
date > ${log_path}
top -bn 1 >> ${log_path}
echo "##########" >> ${log_path}

#Executive summary
date >> ${exec_sum_log_path}
grep load ${log_path} >> ${exec_sum_log_path}
grep MiB ${log_path} >> ${exec_sum_log_path}
echo "##########" >> ${exec_sum_log_path}

#easiest way to figure out how long for 5 days
#1 min*mins in day* how many days * 5 lines to check days old
line_check_total=$(expr 1440 \* ${days_to_keep_log} \* 5)
check_line_in_exec_sum=$(wc -l ${exec_sum_log_path} | awk '{print $1}')

if [ "${check_line_in_exec_sum}" -gt "${line_check_total}" ];
then
    echo "" > ${exec_sum_log_path}
fi
