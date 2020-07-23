#!/bin/bash
# handy installer after fw upgrades
# https://wiki.mobileread.com/wiki/Optware

optMount="/mnt/optware"

mntOpt(){
  if [ ! -d "$optMount" ]; then
    mntroot rw
    mkdir -v "$optMount"
    mntroot ro
  fi
  mount -v -o loop,noatime -t ext3 /mnt/us/optware.ext3 $optMount
}

opt="$optMount/opt"

optDirs(){
  if [ ! -d "$opt" ]; then
    mkdir -p -v $opt
    cd $opt
    mkdir -p -v bin sbin etc info man share tmp lib
  fi
}

linkOpt(){
  if [ ! -d "/opt/bin" ]; then
    cd /opt
    mntroot rw
    ln -s "$opt/bin" .
    ln -s "$opt/sbin" .
    ln -s "$opt/etc" .
    ln -s "$opt/info" .
    ln -s "$opt/man" .
    ln -s "$opt/share" .
    ln -s "$opt/tmp" .
    ln -s "$opt/lib" .
    mntroot ro
  fi
}

mntOpt
optDirs
linkOpt