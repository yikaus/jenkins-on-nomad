#!/bin/bash 
ansible-playbook -i ",$1"  --private-key=$2 jenkins.yaml