Documenting how to run the playbook
====================================

Clone Repository for linux AD on ansible control node
------------------------------------------------------

git clone https://gitlab.domain.local/ansible/playbooks/linux-ad-integration.git

Install Role
------------------------------------------------------

ansible-galaxy role install -r linux-ad-integration/requirements.yml

Clone disa.stig Repository
------------------------------------------------------

git clone https://gitlab.domain.local/ansible/roles/disa.stig.git

Checkout CentOS branch
------------------------------------------------------

cd disa.stig && git checkout CentOS

update config/hosts with the machines to target
------------------------------------------------------

Add machine names to the config/hosts file to ensure they are targetted.


Run Playbook
-------------

cd rhel7STIG-ansible
read -s PASS
ansible-playbook centos-stig.yml -i "localhost," -c local -e join_user=<USER> -e join_pass=$PASS -K
