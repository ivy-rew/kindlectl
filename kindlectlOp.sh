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