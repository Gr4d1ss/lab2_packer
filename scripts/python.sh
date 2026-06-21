#!/bin/bash
#
# A bash script for installing Python 3.7.2 on your Debian, Ubuntu or Mint server.
# (c) 2019 Valentin B.
#
# Open your terminal and enter the following command:
# wget https://gist.github.com/vbe0201/b85ec47bc198d1c8471acbf016922005/raw/get-python.sh && chmod +x get-python.sh && ./get-python.sh

echo 'Install python'

apt update -y
apt upgrade -y

apt install build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev -y

mkdir python_installation && cd python_installation

wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
tar xzvf Python-3.7.2.tgz
rm -f Python-3.7.2.tgz

cd Python-3.7.2
./configure --enable-optimizations
make -j 4
make altinstall

cd ../..
rm -rf python_installation

apt --purge remove build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev -y
apt autoremove -y
apt clean

python3.7 -m pip install -U pip
echo '$alias pip3="python3.7 -m pip"' >> ~/.bashrc
