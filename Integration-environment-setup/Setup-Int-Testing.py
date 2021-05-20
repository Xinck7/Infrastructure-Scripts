#!/usr/bin/python
#Author: Nickolaus Vendel
#Date: 5-29-20
#Version 1.0

import os, sys, socket, subprocess, platform

##########################
##Start Basic user Setup##
##########################


#Warnings before starting script
print("1. Ensure there are no spaces in the name! use underscores instead")
print("2. Make sure before you install you have the following terms to match for your install on the iso name")
print("       For software_1 'RHEL', 'Centos'")
print("       For software_2 'RHEL_7', 'RHEL_6', 'Supp'")
print("3. Make sure you have the files in the same folder you specify as the 'parent path'")


#Mark desired installs 
print("Install the most recent ASVR SRT build? type y or n")
install_software_1_build = raw_input()
if install_software_1_build == 'y':
    install_software_1_build = True
    print("please enter the /capsvr/TESTGROUP/Software-Installs/ parent path to install for int testing")
    #print("eg: /capsvr/TEST_GROUP/Software-Installs/SRT_Added_from_CM/software_1/Current_SRT/")
    print("/capsvr/TEST_GROUP/Software-Installs/Sprint\ Versions/censored_Path/")
    software_1_iso_path = raw_input()


print("Install the most recent software_2 SRT build? type y or n")
install_software_2_build = raw_input()
if install_software_2_build == 'y':
    install_software_2_build = True
    print("please enter the /capsvr/TESTGROUP/Software-Installs/ path to install for int testing")
    print("/capsvr/TEST_GROUP/Software-Installs/SRT_Added_from_CM/software_2/Current_SRT_Linux/")
    software_2_iso_path = raw_input()


#Create Mount Points
mount_paths = ["/capsvr", "/media-support", "/media-install", "/tmp/forsetup"]
for i in mount_paths:
    os.mkdir( i, 755 )

########################
##End Basic user Setup##
########################

###############################
###Gather system information###
###############################

# install mounting tools required
cmd = 'yum install -y cifs-utils'
os.system(cmd)


# Disable rhel native repos
cmd = 'subscription-manager repos --disable=*'
os.system(cmd)


# Get software_1 information
version_number = platform.linux_distribution()[1]


# get Hostname
domain_name = socket.gethostname()


# gather Nic for labnet for puppet master
cmd = "touch /tmp/forsetup/ip.txt"
os.system(cmd)
if version_number == '7.7':
    cmd = 'ip addr | grep  -B2 172.18 | cut -c3-9 > /tmp/forsetup/ip.txt'
    os.system(cmd)
    with open('/tmp/forsetup/ip.txt', 'r') as file:
        lab_net_nic = file.read().replace('\n', '')
        lab_net_nic = lab_net_nic.split(" ")[1]
        file.close()
else:
    cmd = 'ifconfig | grep -B2 172.18 |cut -c1-4 > /tmp/forsetup/ip.txt'
    os.system(cmd)
    with open('/tmp/forsetup/ip.txt', 'r') as file:
        lab_net_nic = file.read().replace('\n', '')
        file.close()

###################################
###End Gather system information###
###################################

###########################
###Configuration Section###
###########################

#configure etc fstab for capsvr
if version_number == '7.7':
    cmd = 'echo "//192.18.109.1/<fileserver-location>  /capsvr     cifs    defaults,password=<password>,vers=1.0  0 0" >> /etc/fstab'
    os.system(cmd)
    cmd = 'mount /capsvr'
    os.system(cmd)
else:
    cmd = 'echo "//192.18.109.1/<fileserver-location>  /capsvr     cifs    defaults,password=<password>  0 0" >> /etc/fstab'
    os.system(cmd)
    cmd = 'mount /capsvr'
    os.system(cmd)


# software_1 iso's
if install_software_1_build == True:
    cmd = "touch /tmp/forsetup/software_1isolist.txt"
    software_1isolist = "/tmp/forsetup/software_1isolist.txt"
    os.system(cmd)
    cmd = "find "+ software_1_iso_path + "*.iso > /tmp/forsetup/software_1isolist.txt"
    os.system(cmd)


# software_2 iso list
if install_software_2_build == True:
    cmd = "touch /tmp/forsetup/software_2isolist.txt"
    software_2isolist = "/tmp/forsetup/software_2isolist.txt"
    os.system(cmd)
    cmd = "find " + software_2_iso_path + "*.iso > /tmp/forsetup/software_2isolist.txt"
    os.system(cmd)


# unmount iso's
def umount_isos():
    cmd = "umount /media-install"
    os.system(cmd)
    cmd = "umount /media-support"
    os.system(cmd)
    print("Iso's have been unmounted")


# Installs proper repositories and runs puppet masters
def installrepos(mount_paths):
    # Mount iso's points
    for i in mount_paths:
        if i == supp_path:
            cmd = "mount -t iso9660 -o loop " + i + " /media-support"
        else:
            cmd = "mount -t iso9660 -o loop " + i + " /media-install"
        os.system(cmd)
    # Setup repos
    cmd = "/media-support/setupLocalRepo.sh -d /opt"
    os.system(cmd)
    cmd = "/media-install/setupLocalRepo.sh -d /opt"
    os.system(cmd)
    cmd = "/media-install/setupPuppetMaster.sh -f " + domain_name + " -n " + lab_net_nic
    os.system(cmd)
    umount_isos()
    print("Repositories have been configured")

#format the lines properly if there is any spaces will escape them for linus
def replace_spaces(file_in):
    file_out = open('/tmp/temp.txt', "w")
    with open(file_in, 'rw') as file:
        for line in file.readlines():
            file_out.write(line.replace(" ", r"\ "))
    file.close()
    file_out.close()
    cmd = 'mv -f /tmp/temp.txt ' + file_in
    os.system(cmd)


#format the lines properly if there is any spaces will escape them for linus
def replace_spaces(file_in):
    file_out = open('/tmp/temp.txt', "w")
    with open(file_in, 'rw') as file:
        for line in file.readlines():
            file_out.write(line.replace(" ", r"\ "))
    file.close()
    file_out.close()
    cmd = 'mv -f /tmp/temp.txt ' + file_in
    os.system(cmd)


# software_1 Section for repos and puppet master
if install_software_1_build == True:
    replace_spaces(software_1isolist)
    with open(software_1isolist, 'r') as file:
        iso_list = file.readlines()
        if "Red Hat" in platform.linux_distribution()[0]:
            supp_path = filter(lambda k: 'RHEL' in k, iso_list)
            supp_path = supp_path[0][:-1]
            for item in iso_list:
                if not ('RHEL' or 'Centos') in item:
                    iso_path = item
                    iso_path = iso_path[:-1]
        else:
            supp_path = filter(lambda k: 'Centos' in k, iso_list)
            for item in iso_list:
                if not ('RHEL' or 'Centos') in item:
                    iso_path = item
                    iso_path = iso_path[:-1]
        file.close()
    mount_paths = [supp_path, iso_path]
    print("Installing software_1")
    installrepos(mount_paths)


# software_2 Section for repos and puppet master
if install_software_2_build == True:
    replace_spaces(software_2isolist)
    with open(software_2isolist, 'r') as file:
        iso_list= file.readlines()
        if version_number == '7.7':
            supp_path = filter(lambda k: 'Supp' in k, iso_list)
            supp_path = supp_path[0][:-1]
            iso_path = filter(lambda k: 'RHEL_7' in k, iso_list)
            iso_path = iso_path[0][:-1]
        else:
            supp_path = filter(lambda k: 'Supp' in k, iso_list)
            supp_path = supp_path[0][:-1]
            iso_path = filter(lambda k: 'RHEL_6' in k, iso_list)
            iso_path = iso_path[0][:-1]
        file.close()
    mount_paths = [supp_path, iso_path]
    print("Installing software_2")
    installrepos(mount_paths)


# Move into .backups of yamls
software_1_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/<software1_folder>/data/aimes_software_1_site.yaml'
software_2_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/software_2/data/software_2_site.yaml'

###############################
###End Configuration Section###
###############################

###################################
###Cleanup and Complete messages###
###################################

# cleanup directories
cmd = 'rm -rf /tmp/forsetup/'
os.system(cmd)


# Print that its done
print("##########################################")
print("Need to source puppet with\n '# source /etc/profile.d/puppet-agent.sh'")
ready_for_puppet = "Ensure YAML's are configured properly either by script or manually \nthen run puppet agent -v"
print("Make sure if software_2 is separate you update the certificates!")
print(ready_for_puppet)
if install_software_1_build == True:
    print(software_1_yaml_path)
if install_software_2_build == True:
    print(software_2_yaml_path)

# END