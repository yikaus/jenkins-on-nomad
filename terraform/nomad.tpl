#!/bin/bash -v

#enable consul and nomad
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o /tmp/nomad.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -o /tmp/consul.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip -o /tmp/consul_ui.zip
unzip /tmp/nomad.zip -d /usr/bin
unzip /tmp/consul.zip -d /usr/bin
mkdir -p /lib/consul/ui
unzip /tmp/consul_ui.zip -d /lib/consul/ui

