#!/bin/bash -eux

echo 'Install vagrant'
apt update

curl -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb

apt install ./vagrant_2.2.6_x86_64.deb

rm vagrant_2.2.6_x86_64.deb

vagrant --version

