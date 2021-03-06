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

screenshot(){
  ctlKindle com.lab126.system takeScreenShot 1
}

path2url(){
  bookUrl=$(python -c "import sys, urllib as ul; print ul.pathname2url('$1')")
  echo "$bookUrl"
}

openBook(){ # qualified path to book (e.g. mnt/us/kindlectl/props.txt).
  thebook=$(path2url "$1")
  echo "opening book: $thebook"
  openApp "com.lab126.booklet.reader/$thebook"
}

openHome(){
  openApp "com.lab126.booklet.home"
}

openBrowser(){ # accept one param stating the URL to open
  openApp "com.lab126.browser?view=$1"
}

openApp(){
  lipc-set-prop com.lab126.appmgrd start "app://$1"
}

openTerm(){ # accept one param stating a command to run in the new term
  local kterm="/mnt/us/extensions/kterm/bin/kterm.sh"
  if [ ! -f $kterm ]; then
    echo "Kindle Terminal seems not to be installed in path ${kterm}"
    echo "visit https://www.fabiszewski.net/kindle-terminal/ to get it."
    exit 2
  fi
  $kterm -o R -k 0 -s 6 -e $1
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