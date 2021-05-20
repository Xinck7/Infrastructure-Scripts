#!/usr/bin/python
#Author: Nickolaus Vendel
#Date: 5-29-20
#Version 1.0
import os, shutil

#Current Path to backup
software_1_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/software_1/data/software_site_1.yaml'
software_2_yaml_path = '/etc/puppetlabs/code/environments/production/modules/apps/software_2/data/software_site_2.yaml'

print("Copy the most recent Yaml's? y/n")
install_yamls = raw_input()

if os.path.isfile(software_1_yaml_path):
    install_software_1_build = True
if os.path.isfile(software_2_yaml_path):
    install_software_2_build = True

if install_yamls == 'y':
    install_yamls = True
    print("Is software_2 colocated? type y or n")
    software_2_together = raw_input()
    if (software_2_together == 'y'):
        print("finished copying conf files")
        software_2_together = True
        if install_software_1_build == True:
            software_1_yaml_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_1-software_2-colocated/software_site_1.yaml'
            print("software_1 conf yaml collected")
        if install_software_2_build == True:
            software_2_yaml_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_1-software_2-colocated/software_site_2.yaml'
            print("software_2 conf yaml collected")
            print("Make sure if software_2 is separate you update the certificates!")
    else:
        if install_software_1_build == True:
            software_1_yaml_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_1-separate-software_2/software_site_1.yaml'
            print("software_1 conf yaml collected")
        if install_software_2_build == True:
            software_2_yaml_copy_path = '/capsvr/TEST_GROUP/<username>/Configuration-files/software_2-separate-yaml/software_site_2.yaml'
            print("software_2 conf yaml collected")
            print("Make sure if software_2 is separate you update the certificates!")

if install_yamls == True:
    if install_software_1_build == True:
        dst = '/etc/puppetlabs/code/environments/production/modules/apps/software_1/data/software_site_1.yaml.bak'
        os.rename(software_1_yaml_path, dst)
        shutil.copy(software_1_yaml_copy_path, software_1_yaml_path)
    if install_software_2_build == True:
        dst = '/etc/puppetlabs/code/environments/production/modules/apps/software_2/data/software_site_2.yaml.bak'
        os.rename(software_2_yaml_path, dst)
        shutil.copy(software_2_yaml_copy_path, software_2_yaml_path)