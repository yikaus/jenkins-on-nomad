#!/bin/bash -v

#install docker
locale-gen en_AU.UTF-8
echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/backports.list
apt-get update
apt-get install -qq apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -qq docker-engine

#install nfs client
apt-get install -qq nfs-common curl unzip
mkdir /efs
echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${efs_id}.efs.us-east-1.amazonaws.com:/ /efs nfs4 defaults" >> /etc/fstab
mount -a

gpasswd -a admin docker
systemctl restart docker