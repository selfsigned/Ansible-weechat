#!/bin/bash
# Setup an ubuntu server ec2 instance for weechat

TARGET_FILE="target"
PLAYBOOKS="install-weechat.yml"
USER="ubuntu"
HOST="$(cat $TARGET_FILE | awk '{print $1}')"

echo "Installing python (hard requirement for ansible)"
ssh $USER@$HOST "sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install python"

ansible-playbook -i $TARGET_FILE install-weechat.yml
