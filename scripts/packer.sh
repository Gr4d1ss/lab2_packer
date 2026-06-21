#!/bin/bash -eux

echo 'Install packer'

sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/hashicorp.gpg

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt update && sudo apt install packer -y 

packer --version