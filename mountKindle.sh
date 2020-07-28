#!/bin/bash
mountpoint="/mnt/kindle"

mountKindle(){
  device=192.168.15.244
  sudo mkdir -pv $mountpoint
  sudo sshfs -o allow_other -o reconnect root@$device:/mnt/us $mountpoint
  echo "done: use $mountpoint"
}

unmountKindle(){
  echo "disconnecting kindle from: $mountpoint"
  sudo fusermount -u $mountpoint
}

if [[ "$1" != "u" ]]; then
  mountKindle
else
  unmountKindle
fi
