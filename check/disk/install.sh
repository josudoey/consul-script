#!/bin/bash
prefix=${repo:-https://github.com/josudoey/consul-script/raw/master}
curl -fLo /usr/local/bin/check-disk $prefix/check/disk/check-disk
chmod +x /usr/local/bin/check-disk
curl -fLo /etc/consul.d/disk.json $prefix/check/disk/disk.json
echo "===you need reload consul==="
echo "consul reload"
