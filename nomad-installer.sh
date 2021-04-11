#!/bin/bash

export NOMAD_VERSION="$1"

sudo apt install unzip

mkdir --parent $HOME/install
cd $HOME/install

curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip

sudo chown root:root nomad
sudo mv nomad /usr/local/bin/

sudo mkdir --parents /etc/nomad.d
sudo chmod 700 /etc/nomad.d


sudo touch /etc/nomad.d/nomad.hcl
cat << EOF > /etc/nomad.d/nomad.hcl
# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "dc1"


server {
	enabled = true
	bootstrap_expect = 1
}

client {
	enabled = true
	servers = ["127.0.0.1:4646"]
}
EOF


sudo touch /etc/nomad.d/server.hcl
cat << EOF > /etc/nomad.d/server.hcl
server {
	enabled = true
	bootstrap_expect = 3
}
EOF


sudo touch /etc/nomad.d/client.hcl
cat << EOF > /etc/nomad.d/client.hcl
client {
	enabled = true
}
EOF

sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad