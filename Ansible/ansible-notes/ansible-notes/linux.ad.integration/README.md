Role Name
=========

Inegrates a Linux host with Active Directory

Requirements
------------

None

Role Variables
--------------

Controls what packages will be installed (see `vars/main.yml`)

    ad_packages:
      - sssd
      - realmd
      - oddjob
      - oddjob-mkhomedir 
      - adcli 
      - samba-common
      - samba-common-tools 
      - krb5-workstation 
      - openldap-clients 
      - policycoreutils-python 

Controls what Domain to join (see `defaults/main.yml`)

    domain: domain.local

Required variables

    join_user: username # Any user in the Domain Admins group
    join_pass: password # This can be encrypted with vault

Dependencies
------------

None

Example Playbook
----------------

    ---
    - hosts: localhost
      connection: local
      become: true

      vars_files: ad.yml

      roles:
        - linux.ad.integration

