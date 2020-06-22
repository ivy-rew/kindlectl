#!/bin/sh
#cd $(dirname "$0")
cd /mnt/us/kindlevncviewer
LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

orient=`lipc-get-prop com.lab126.winmgr orientationLock`
echo "orientiation is $orient"

lipc-set-prop com.lab126.powerd preventScreenSaver 1
lipc-set-prop com.lab126.winmgr orientationLock R

refresh(){
  while :
  do
    eips ''
    #lipc-set-prop com.lab126.winmcdgr orientationLock U
    usleep 80000
  done
}

leave(){
  echo 'bye bye'
  lipc-set-prop com.lab126.powerd preventScreenSaver 0
  lipc-set-prop com.lab126.winmgr orientationLock $orient
  pkill kindlevncviewer
  exit
}

vncUi(){
  echo "hoi"
}

sleep
trap leave SIGINT

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
refresh
