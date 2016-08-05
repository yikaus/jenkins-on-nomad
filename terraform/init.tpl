#!/bin/bash -v

#install docker
echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/backports.list
echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -qq apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get install -qq docker-engine
sudo gpasswd -a admin docker
service docker restart

#install nfs client
apt-get install -qq nfs-utils nfs-common curl

echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${efs_id}.efs.us-east-1.amazonaws.com:/ /efs nfs4 defaults" >> /etc/fstab

mount -a