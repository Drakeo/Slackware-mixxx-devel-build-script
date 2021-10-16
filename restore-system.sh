#!/bin/bash
removepkg chromaprint
removepkg faad2
removepkg google-apputils
removepkg hidapi
removepkg jack2
removepkg ladspa_sdk
removepkg libebur128 
removepkg libmp4v2
removepkg libopenmpt 
removepkg libopenmpt-modplug
removepkg libshout
removepkg lilv
removepkg lv2
removepkg mixxx
removepkg mxml 
removepkg portaudio 
removepkg portmidi  
removepkg protobuf
removepkg python-dateutil
removepkg python-gflags
removepkg pytz
removepkg qjackctl
removepkg QUSB
removepkg rubberband
removepkg serd
removepkg set_rlimits
removepkg sord  
removepkg soundtouch
removepkg sratom    
removepkg vamp-plugin-sdk  
# reinstall the  default slackware packages.
slackpkg reinstall alsa-plugins 
slackpkg reinstall pulseaudio
slackpkg upgrade pulseaudio
slackpkg upgrade alsa-plugins  

 
