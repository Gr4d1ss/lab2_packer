#!/bin/bash
echo 'Install redis'

curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://deb.mirror.yandex.ru/mirrors/packages.redis.io $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

apt update -y
apt-get install redis -y

service redis-server start


