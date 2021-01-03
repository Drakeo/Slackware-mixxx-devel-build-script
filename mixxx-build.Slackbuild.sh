#!/bin/sh

# Copyright 2012  Patrick J. Volkerding, Sebeka, Minnesota, USA
# All rights reserved.
#
# Copyright 2013 Chess Griffin <chess.griffin@gmail.com> Raleigh, NC
# Copyright 2013 Willy Sudiarto Raharjo <willysr@slackware-id.org>
# All rights reserved.
#
# Based on the xfce-build-all.sh script by Patrick J. Volkerding
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# Set to 1 if you'd like to install/upgrade package as they are built.
# This is recommended.

#We need jdk development look for openjdk or jdk this is needed to build portmidi
 if [ -f  /etc/profile.d/openjdk.sh ]; then
     JAVA="openjdk.sh"   
 fi
 
 if [ -f  /etc/profile.d/jdk.sh ]; then
     JAVA="jdk.sh"
 fi
     
 if [ -f  /etc/profile.d/$JAVA ]; then
       . /etc/profile.d/$JAVA
 else
  echo -e "\e[1;33m you must install JDK or openjdk.\e[0m"   
  echo -e "\e[1;33m http://www.slackware.com/~alien/slackbuilds/openjdk .\e[0m" 
   exit 1
fi
  
 if [ -f /usr/bin/ffmpeg ]; then
     FFMPG="ffmpeg" 
 else
   echo -e "\e[1;33m you must install ffmpeg.\e[0m"   
  echo -e "\e[1;33m http://www.slackware.com/~alien/slackbuilds/ffmpeg .\e[0m" 
  exit 1
 fi
  

INST=1

# This is where all the compilation and final results will be placed
TMP=${TMP:-/tmp}

# This is the original directory where you started this script
MIXXXROOT=$(pwd)

# Loop for all packages
for dir in \
  buildmixxx/set_rlimits \
  buildmixxx/libebur128 \
  buildmixxx/hidapi \
  buildmixxx/QUSB \
  buildmixxx/libmodplug \
  buildmixxx/faad2 \
  buildmixxx/soundtouch \
  buildmixxx/libmp4v2 \
  buildmixxx/serd \
  buildmixxx/sord \
  buildmixxx/lv2 \
  buildmixxx/sratom \
  buildmixxx/lilv \
  buildmixxx/pytz \
  buildmixxx/pysetuptools \
  buildmixxx/python-gflags \
  buildmixxx/google-apputils \
  buildmixxx/python-dateutil\
  buildmixxx/jack2 \
  buildmixxx/protobuf \
  buildmixxx/chromaprint \
  buildmixxx/ladspa_sdk  \
  buildmixxx/libshout \
  buildmixxx/portaudio \
  buildmixxx/portmidi \
  buildmixxx/vamp-plugin-sdk \
  buildmixxx/rubberband \
  buildmixxx/pulseaudio \
  buildmixxx/alsa-plugins \
  buildmixxx/qjackctl \
  buildmixxx/mixxx \
  ; do
  # Get the package name
  package=$(echo $dir | cut -f2- -d /) 
  
  # Change to package directory
  cd $MIXXXROOT/$dir || exit 1 

  # Get the version
  version=$(cat ${package}.SlackBuild | grep "VERSION:" | cut -d "-" -f2 | rev | cut -c 2- | rev)

  # Check for duplicate sources
  sourcefile="$(ls -l $MIXXXROOT/$dir/${package}-*.tar.?z* | wc -l)"
  if [ $sourcefile -gt 1 ]; then
    echo "You have following duplicate sources:"
    ls $MIXXXROOT/$dir/${package}-*.tar.?z* | cut -d " " -f1
    echo "Please delete sources other than ${package}-$version to avoid problems"
    exit 1
  fi
  
  # The real build starts here
  sh ${package}.SlackBuild || exit 1
  if [ "$INST" = "1" ]; then
    PACKAGE="${package}-$version-*.tgz"
    if [ -f $TMP/$PACKAGE ]; then
      upgradepkg --install-new --reinstall $TMP/$PACKAGE
    else
      echo "Error:  package to upgrade "$PACKAGE" not found in $TMP"
      exit 1
    fi
  fi
  
  # back to original directory
  cd $MIXXXROOT
done
