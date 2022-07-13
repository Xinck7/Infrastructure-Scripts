# Local Active Directory Integration 

## Clone Repository

    git clone https://gitlab.domain.local/ansible/playbooks/linux-ad-integration

## Install Role

    ansible-galaxy role install -r requirements.yml

## Run Playbook 

    ansible-playbook -i "localhost," local-ad-integration.yml -K