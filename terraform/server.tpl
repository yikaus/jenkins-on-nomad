#!/bin/bash -v

#enable consul and nomad
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o /tmp/nomad.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -o /tmp/consul.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip -o /tmp/consul_ui.zip
unzip /tmp/nomad.zip -d /usr/bin
unzip /tmp/consul.zip -d /usr/bin
mkdir -p /lib/consul/ui
unzip /tmp/consul_ui.zip -d /lib/consul/ui

private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /etc/consul
{
  "data_dir": "/tmp/consul",
  "log_level": "INFO",
  "server": true,
  "bind_addr": "$private_ip",
  "client_addr": "$private_ip",
  "ui_dir": "/lib/consul/ui",
  "bootstrap_expect": 1
}
EOF

cat <<EOF > /etc/nomad
region = "${region}"
datacenter = "dc1"
bind_addr = "$private_ip"
log_level = "INFO"
data_dir = "/tmp/nomad"
server {
    enabled = true
    bootstrap_expect = 1
}
client {
	enabled = true
	servers = ["$private_ip:4647"]
        options = {
          consul.address = "$private_ip:8500"
         }
}
EOF

cat <<EOF > /lib/systemd/system/consul.service
[Unit]
Description=Consul
[Service]
ExecStart=/usr/bin/consul agent -config-file /etc/consul
[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /lib/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
[Service]
ExecStart=/usr/bin/nomad agent -config /etc/nomad
[Install]
WantedBy=multi-user.target
EOF

systemctl enable consul.service nomad.service
systemctl start consul.service nomad.service
