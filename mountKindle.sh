#!/bin/bash
mountpoint="/mnt/kindle"
sudo mkdir -p $mountpoint
sudo sshfs -o allow_other root@kindle:/mnt/us $mountpoint
echo "done: use $mountpoint"
