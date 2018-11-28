#!/bin/bash
# Setup an ubuntu server ec2 instance for weechat

DEFAULT_USER="ubuntu" # default value on aws
TERRAFORM_DIR="terraform/"

prompt_confirmation () {
    read -p "$1" choice
    case "$choice" in
        y|Y ) return;;
        n|N ) exit;;
        * ) echo "Invalid answer"; exit;;
    esac
}

TARGET_FILE="target"
PLAYBOOKS="install-weechat.yml"

# terraform
run_terraform () {
    cd $TERRAFORM_DIR
    terraform init
    terraform plan ; prompt_confirmation "Apply the configuration (y/n)? "
    terraform apply -auto-approve
    HOST=$(terraform state show aws_instance.irc | grep "^public_ip" | awk '{print $3}')
    cd ..

    echo $HOST > target
}

# dependencies needed to run ansible on the guest
install_deps() {
    HOST="$(cat $TARGET_FILE | awk '{print $1}')"

    echo "Installing python (hard requirement for ansible)"
    ssh $DEFAULT_USER@$HOST "sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install python"
}

run_ansible () {
    ansible-playbook -i $TARGET_FILE install-weechat.yml
}

run_terraform
#install_deps
run_ansible
