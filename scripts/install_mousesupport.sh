#!/bin/bash -eux

apt-get install software-properties-common
apt-add-repository universe

apt-get update
apt-get install gpm -y

