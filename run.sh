#!/bin/bash

set -xe

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

echo nameserver 1.1.1.1 > /etc/resolv.conf
echo 127.0.0.1 localhost > /etc/hosts

/usr/sbin/sshd &

/usr/bin/caddy run -config /etc/caddy/Caddyfile &


( source /etc/rc.local ) &

sleep infinity
