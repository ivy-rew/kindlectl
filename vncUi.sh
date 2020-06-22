#!/bin/sh

. kindlectlOp.sh

#cd $(dirname "$0")
cd /mnt/us/kindlevncviewer
LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

orient=$(orientation)
echo "orientiation is $orient"

preventScreensaver 1
orientation R

refresh(){
  while :
  do
    eips ''
    usleep 80000
  done
}

leave(){
  echo 'bye bye'
  preventScreensaver 0
  orientation $orient
  pkill kindlevncviewer
  exit
}

vncUi(){
  eips 4 4 -h "CONNECTING TO VNC" "$@"
  local address=$(dialog --inputbox "connect to VNC [ip:port]" 10 30 192.168.15.201:5903 2>&1 >/dev/tty)
  if [[ "$address" -eq 255 ]]; then
    return;
  fi
  local passwd=$(dialog --passwordbox "password for ${address}" 10 30 2>&1 >/dev/tty)
  if [[ "$passwd" -eq 255 ]]; then
    return;
  fi
  ./kindlevncviewer -config config.lua -password $passwd $address "$@" &
}

trap leave SIGINT
vncUi
refresh

