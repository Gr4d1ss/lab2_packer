#!/bin/bash -eux

echo 'Install terraform'

wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
sudo apt install unzip -y
sudo unzip terraform_1.5.6_linux_amd64.zip -d /usr/local/bin
sudo rm terraform_1.5.6_linux_amd64.zip

terraform -help

