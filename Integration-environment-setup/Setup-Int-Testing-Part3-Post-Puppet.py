#!/usr/bin/python
#Author: Nickolaus Vendel
#Date: 5-29-20
#Version 1.0
import os, shutil, platform, time, socket
from string import Template

#Get RHEL OS number
version_number = platform.linux_distribution()[1]
# get Hostname
domain_name = socket.gethostname()

print("Would you like to import the last known working feeds .ini file?")
print("You will still need to configure the correct IP addresses to your IP sources type y or n")
current_ini = raw_input()
#current_ini = 'y'

software_2_ini_path = '/opt/Leidos/software_2/user_config/software_2Config.ini'

#Setup logic for ini
print("Do you want to update the config.ini file if found? type y or n")
update_ini = raw_input()
#update_ini = 'y'
if update_ini == 'y':
    update_ini = True

#Check if software_2 is colocated
software_1_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/software_1_folder/data/aimes_software_1_site.yaml'
software_2_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/software_2/data/software_2_site.yaml'

if os.path.isfile(software_1_yaml_path):
    install_software_1_build = True

if os.path.isfile(software_2_yaml_path):
    install_software_2_build = True


#Sets variable and path to copy from for the configuration file
if update_ini == True:
    if ((install_software_1_build == True) and (install_software_2_build == True)):
        software_2_ini_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_2-config-ini/Colocated/software_2Config.ini'
        print("finished copying ini file")
    else:
        software_2_ini_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_2-config-ini/Separate/software_2Config.ini'
        print("finished copying ini file")


#Backup original .ini and copy in the 'configured' ini (still needs IP adjustments)
if update_ini == True:
        shutil.copy(software_2_ini_copy_path, software_2_ini_path)


# gather Nic ip's for nic addresses
if update_ini == True:
    cmd = "touch /tmp/ip.txt"
    os.system(cmd)
    if version_number == '7.7':
        #18 net
        cmd = 'ifconfig | grep 172.18 | cut -c14-27 > /tmp/ip.txt'
        os.system(cmd)
        #28 net
        cmd = 'ifconfig | grep 172.28 | cut -c14-27 >> /tmp/ip.txt'
        os.system(cmd)
        #38 net
        cmd = 'ifconfig | grep 172.38 | cut -c14-27 >> /tmp/ip.txt'
        os.system(cmd)
        with open('/tmp/ip.txt', 'r') as file:
            file_content = file.readlines()
            nic_18 = file_content[0].rstrip()
            nic_28 = file_content[1].rstrip()
            nic_38 = file_content[2].rstrip()
            file.close()
    else:
        #18 net
        cmd = 'ifconfig | grep 172.18 | cut -c21-34 > /tmp/ip.txt'
        os.system(cmd)
        #28 net
        cmd = 'ifconfig | grep 172.28 | cut -c21-34 >> /tmp/ip.txt'
        os.system(cmd)
        #38 net
        cmd = 'ifconfig | grep 172.38 | cut -c21-34 >> /tmp/ip.txt'
        os.system(cmd)
        with open('/tmp/ip.txt', 'r') as file:
            file_content = file.readlines()
            nic_18 = file_content[0].rstrip()
            nic_28 = file_content[1].rstrip()
            nic_38 = file_content[2].rstrip()
            file.close()


# Variables to match defined in dictionary
broadcast_ip = '225.18' + nic_18[6:]
file_out = open('/tmp/ini.txt', "w")
with open(software_2_ini_path, 'rw') as file:
    d = dict(domain_name = domain_name, broadcast_ip = broadcast_ip, output_ip = nic_18, net_38 = nic_38, net_28 = nic_28)
    for line in file.readlines():
        file_out.write(Template(line).substitute(d))
    file.close()
    file_out.close()


# Move because python 
cmd = 'mv /tmp/ini.txt ' + software_2_ini_path + ' -f'
os.system(cmd)


# Restart software_2
cmd = 'service software_2 stop'
os.system(cmd)
time.sleep(5)
cmd = 'service software_2 start'
os.system(cmd)


#Turns off firewalls/ puppet
cmd = 'puppet agent --disable'
os.system(cmd)
if version_number == '7.7':
    cmd = 'systemctl stop firewalld'
    os.system(cmd)
else:
    cmd = 'service iptables stop'
    os.system(cmd)
    cmd = 'chkconfig iptables off'
    os.system(cmd)

