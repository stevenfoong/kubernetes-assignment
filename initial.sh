# /bin/bash
ssh-keygen -f key
ansible-playbook initial-cluster.yml -e "env=test"
