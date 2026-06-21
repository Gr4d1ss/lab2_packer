#!/bin/bash -eux

echo 'Install app'

sudo /bin/sh -c 'echo "127.0.0.1 redis" >> /etc/hosts'
git clone https://github.com/nigelpoulton/ddd2023.git
cd ddd2023/compose
pip3 install -r requirements.txt
