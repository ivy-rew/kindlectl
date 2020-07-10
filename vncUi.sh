#!/bin/sh

. kindlectlOp.sh

vncDir="/mnt/us/kindlevncviewer"
if [ ! -d "$vncDir" ]; then
  echo "Kindle VNC Viewer seem not to be present in $vncDir"
  echo "Visit https://www.mobileread.com/forums/showthread.php?t=150434 to get it."
fi
cd "$vncDir"
LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

init(){ #tune settings for VNC
  local appId=$(ctlKindle com.lab126.appmgrd activeApp)
  if [[ "$appId" != "com.lab126.booklet.reader" ]]; then
    eips 1 1 -h "opening reader to allow orientation switch!"
    openBook /mnt/us/kindlectl/props.txt
    sleep 5
  fi

  orient=$(orientation)
  echo "orientiation is $orient"
  orientation R
  ssOff=$(preventScreensaver)
  echo "screensaver is $ssOff"
  preventScreensaver 1
}

leave(){ #restore settings+kill vnc
  echo 'bye bye'
  preventScreensaver $ssOff
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

