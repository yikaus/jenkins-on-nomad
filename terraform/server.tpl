#!/bin/bash -v

#enable consul and nomad
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o /tmp/nomad.zip
unzip /tmp/nomad.zip -d /usr/bin

private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

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

systemctl enable nomad.service
systemctl start nomad.service
