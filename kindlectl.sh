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

if [[ "$1" == "dialog" ]]; then
  local choice=$( dialog --menu "terminal kindle configurator" 0 0 0\
   1 "light"\
   2 "power"\
   3 "wifi"\
    2>&1 >/dev/tty )
  case $choice in
    1) lightUi;;
    2) powerUi;;
    3) wifiUi;;
  esac
fi