#!/bin/bash
prefix=${repo:-https://github.com/josudoey/consul-script/raw/master}
if [ -x /usr/local/bin/check-disk ]; then
curl -fLo /usr/local/bin/check-disk $prefix/check/disk/check-disk
chmod +x /usr/local/bin/check-disk
fi
curl -fLo /etc/consul.d/disk.json $prefix/check/disk/disk.json

echo "===reload==="
echo "consul reload"
