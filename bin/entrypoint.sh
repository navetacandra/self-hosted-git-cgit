#!/bin/bash
set -e

/usr/sbin/sshd
service fcgiwrap start
nginx -g 'daemon off;'
