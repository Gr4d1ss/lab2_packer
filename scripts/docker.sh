#!/bin/bash -eux

# Add Docker's official GPG key:
echo 'Install docker'
sudo groupadd docker
sudo usermod -aG docker vagrant

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh


sudo systemctl enable docker

docker --version

