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

preventScreensaver(){ # 0/1 to disable/enable screensaver
  ctlKindle com.lab126.powerd preventScreenSaver $1
}

orientation(){
  ctlKindle com.lab126.winmgr orientationLock $1
}

openBook(){ # qualified path to book (e.g. mnt/us/kindlectl/props.txt). Encode whitespace if any!
  lipc-set-prop com.lab126.appmgrd start "app://com.lab126.booklet.reader/$1"
}

openBrowser(){ # accept one param stating to URL to open
  lipc-set-prop com.lab126.appmgrd start "app://com.lab126.browser?view=$1"
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