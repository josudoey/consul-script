#!/bin/bash -e
which unzip || apt-get install -yyq unzip
version=0.7.5
cd /tmp
mkdir -p /var/lib/consul
mkdir -p /etc/consul.d
wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -O consul_${version}_linux_amd64.zip
wget https://releases.hashicorp.com/consul/${version}/consul_${version}_web_ui.zip -O consul_${version}_web_ui.zip
unzip -B -d /usr/local/bin consul_${version}_linux_amd64.zip
unzip -B -d /var/lib/consul/ui consul_${version}_web_ui.zip


if [ -x /bin/systemctl ]; then
f=/etc/systemd/system/consul.service;test -e $f || tee $f <<EOF
[Service]
ExecStart=/usr/local/bin/consul  agent --config-dir="/etc/consul.d" -bind=`hostname --ip-address`
EOF
else
f=/etc/init/consul.conf;test -e $f || tee $f <<EOF
description "Consul agent"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
exec start-stop-daemon --start --exec /usr/local/bin/consul -- agent --config-dir="/etc/consul.d" -bind=`hostname --ip-address`
EOF
fi

f=/etc/consul.d/config.json;test -e $f || tee $f <<EOF
{
  "bootstrap_expect": 1,
  "server": true,
  "data_dir": "/var/lib/consul",
  "log_level": "INFO",
  "enable_syslog": false,
  "ui_dir": "/var/lib/consul/ui",
  "ports": {
    "dns": 8600,
    "http": 8500,
    "serf_lan": 8301,
    "serf_wan": 8302,
    "server": 8300
  },
  "addresses": {
    "http": "0.0.0.0",
    "dns": "0.0.0.0"
  }
}
EOF

echo "===begin consul service==="
echo "sudo service consul start"
