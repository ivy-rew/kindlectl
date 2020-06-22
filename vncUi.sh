#!/bin/sh

. kindlectlOp.sh

#cd $(dirname "$0")
cd /mnt/us/kindlevncviewer
LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

init(){ #tune settings for VNC
  orient=$(orientation)
  echo "orientiation is $orient"
  preventScreensaver 1
  orientation R
}

leave(){ #restore settings+kill vnc
  echo 'bye bye'
  preventScreensaver 0
  orientation $orient
  pkill kindlevncviewer
  exit
}

refresh(){ # screen draw-refresh
  while :
  do
    eips ''
    usleep 80000
  done
}

vncUi(){
  eips -c
  eips 4 4 -h "CONNECTING TO VNC" "$@"
  local address=$(dialog --inputbox "connect to VNC [ip:port]" 10 30 192.168.15.201:5903 2>&1 >/dev/tty)
  eips 4 5 -h "Address=$address"
  local passwd=$(dialog --passwordbox "password for ${address}" 10 30 2>&1 >/dev/tty)
  eips 4 6 -h "got password... connecting"
  ./kindlevncviewer -config config.lua -password $passwd $address "$@" &
}

init
trap leave SIGINT
vncUi
refresh

