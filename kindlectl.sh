#!/bin/bash

wifiEnabled(){ # accept no params to read state. Or 0/1 to disable/enable wifi.
  if ! [ -z "$1" ]; then
    lipc-set-prop com.lab126.cmd wirelessEnable $1
  fi
  echo "wifi is $(lipc-get-prop com.lab126.cmd wirelessEnable)"
}

readProps(){ # no params or a specific entry to list it's props e.g. com.lab126.cmd
  if ! [ -z "$1" ]; then
    lipc-probe -v $1
  else
    lipc-probe -a
  fi
}

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
if [[ $1 == "wifi" ]]; then
  dialog --yesno "enable wifi" 10 30
  answer=$?
  case $answer in
    0) echo "enabling";wifiEnabled 1;;
    1) echo "disabling";wifiEnabled 0;;
    255) echo "abort";;
  esac
fi