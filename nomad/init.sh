#enable consul and nomad
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o nomad.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -o consul.zip
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip -o consul_ui.zip
unzip nomad.zip -d /usr/bin
unzip consul.zip -d /usr/bin
mkdir -p /lib/consul/ui
unzip consul_ui.zip -d /lib/consul/ui
mv /tmp/*.service  /lib/systemd/system