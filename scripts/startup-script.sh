#!/bin/bash -eux

# Add Docker's official GPG key:
echo 'Start redis-server'
sudo service redis-server start
echo 'Start app'
cd ddd2023/compose
python3 app/app.py




