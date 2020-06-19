#!/bin/bash

wifiEnabled(){ # accept no params to read state. Or 0/1 to disable/enable wifi.
  ctlKindle com.lab126.cmd wirelessEnable $1
}

light(){ # dim paperwhite light. Accept int 0-25 ...
  ctlKindle com.lab126.powerd flIntensity $1
}

powerToggle(){
  ctlKindle com.lab126.powerd powerButton 0
}

powerStatus(){
  ctlKindle com.lab126.powerd status
}

ctlKindle(){ # change or read kindle ctrl property
  local entry="$1"
  local key="$2"
  local val="$3"
  if ! [ -z "$3" ]; then
    lipc-set-prop "$entry" "$key" "$val"
  fi
  echo "$(lipc-get-prop "$entry" "$key")"
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
if [[ "$1" == "wifi" ]]; then
  dialog --yesno "enable wifi \nstate:$(wifiEnabled)" 10 30
  local answer=$?
  case $answer in
    0) echo "enabling";wifiEnabled 1;;
    1) echo "disabling";wifiEnabled 0;;
    255) echo "abort";;
  esac
fi

if [[ "$1" == "light" ]]; then
  local current=$(light)
  dialog --inputbox "select backlight dim [0-25]" 10 30 $current 2> tmpres.txt
  local answer=$?
  case $answer in
     0) dim=$(cat tmpres.txt)
      if [[ "$dim" -gt 0 ]]; then
        echo "light $dim";light $dim
      fi 
     ;;
  esac
fi

if [[ "$1" == "power" ]]; then
  local current=$(powerStatus)
  dialog --msgbox "toggle power? \n\n $current" 20 50
  local answer=$?
  case $answer in
     0) echo "toggling power";powerToggle;;
  esac
fi