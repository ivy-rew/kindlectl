#!/bin/bash

wifiEnabled(){ # accept no params to read state. Or 0/1 to disable/enable wifi.
  if ! [ -z "$1" ]; then
    lipc-set-prop com.lab126.cmd wirelessEnable $1
  fi
  echo "wifi is $(lipc-get-prop com.lab126.cmd wirelessEnable)"
}