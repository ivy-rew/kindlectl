#!/bin/bash

mount -o loop,noatime -t ext3 /mnt/us/optware.ext3 /mnt/optware
export PATH=$PATH:/mnt/optware/opt/bin
alias apt='ipkg -t /opt/tmp "$@"'
