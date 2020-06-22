#!/bin/bash

. kindlectlOp.sh

# deps
if [ ! -d "/mnt/optware/opt/bin" ]; then
  echo "optware not found!"
  exit 1
fi
if [ ! -z "${PATH##*optware*}" ]; then
  export PATH=$PATH:/mnt/optware/opt/bin
fi
type dialog >/dev/null 2>&1 || { echo >&2 "installing dialog"; ipkg -t /opt/tmp install dialog; }


## UI
wifiUi(){
  dialog --yesno "enable wifi \nstate:$(wifiEnabled)" 10 30
  local answer=$?
  case $answer in
    0) echo "enabling";wifiEnabled 1;;
    1) echo "disabling";wifiEnabled 0;;
    255) echo "abort";;
  esac
}

lightUi(){
  local current=$(light)
  local dim=$(dialog --inputbox "select backlight dim [0-25]" 10 30 $current 2>&1 >/dev/tty)
  if [[ "$dim" -lt 255 ]]; then
    echo "light $dim";light $dim
  fi
}

powerUi(){
  local current=$(powerStatus)
  dialog --msgbox "toggle power? \n\n $current" 20 50
  local answer=$?
  case $answer in
     0) echo "toggling power";powerToggle;;
  esac
}

screensaverUi(){
  dialog --yesno "prevent screensaver \nstate:$(preventScreensaver)" 10 30
  local answer=$?
  case $answer in
    0) echo "enabling";preventScreensaver 1;;
    1) echo "disabling";preventScreensaver 0;;
    255) echo "abort";;
  esac
}

terminalUi(){
  local cmd=$(dialog --inputbox "enter a command to run" 10 30 $1 2>&1 >/dev/tty)
  if [[ "$cmd" != 255 ]]; then
    openTerm $cmd
  fi
}

browseUi(){
  local uri=$(dialog --inputbox "select an URL" 10 30 http://www.amazon.com 2>&1 >/dev/tty)
  if [[ "$uri" != 255 ]]; then
    openBrowser $uri
  fi
}

if [[ "$1" != "test" ]]; then
  local choice=$( dialog --menu "terminal kindle configurator" 0 0 0\
   1 "light"\
   2 "power"\
   3 "screensaver"\
   4 "wifi"\
   5 "vnc"\
   6 "terminal"\
   7 "create shared terminal"\
   8 "connect shared terminal"\
   9 "browse"\
    2>&1 >/dev/tty )
  case $choice in
    1) lightUi;;
    2) powerUi;;
    3) screensaverUi;;
    4) wifiUi;;
    5) echo "open VNC";vnc=$(./vncUi.sh);;
    6) terminalUi;;
    7) openTerm /mnt/optware/opt/bin/screen & ;;
    8) . termInfo.sh && /mnt/optware/opt/bin/screen -xr;;
    9) browseUi;;
  esac
fi