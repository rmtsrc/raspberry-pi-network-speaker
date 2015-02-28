#!/bin/bash

# Raspberry Pi Network Speaker provisioner v0.0.1
# https://github.com/sebflipper/raspberry-pi-network-speaker

# Turns your Raspberry Pi into Network Speaker supporting Apple AirPlay and UPnP

# Usage
# sudo ./provision.sh <custom_display_name> # custom_display_name is optional


# Working directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

# Display name
DISPLAY_NAME=raspberrypi
if [ -n "$1" ]; then
  DISPLAY_NAME=$1
fi

# Make sure the Pi is upto date <http://www.raspberrypi.org/documentation/raspbian/updating.md>
apt-get -y update
apt-get -y upgrade
rpi-update

# Allow root access to audio
adduser root audio

# START AirPlay

# Install Apple's Bonjour services <http://www.raspberrypi.org/forums/viewtopic.php?f=27&t=34620>
apt-get -y install libnss-mdns

# ShairPort
# Prerequisites
apt-get -y install git libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils libmodule-build-perl

# Perl Net-SDP
git clone https://github.com/njh/perl-net-sdp.git
cd perl-net-sdp
perl Build.PL
./Build
./Build test
./Build install
cd ..

# Install ShairPort
git clone https://github.com/hendrikw82/shairport.git
cd shairport
make
make install

# Autostart ShairPort
cp shairport.init.sample /etc/init.d/shairport
chmod 755 /etc/init.d/shairport
update-rc.d shairport defaults

# Custom display name
sed -i -e "s/DAEMON_ARGS=\"-w \$PIDFILE\"/DAEMON_ARGS=\"-w \$PIDFILE -a $DISPLAY_NAME\"/g" /etc/init.d/shairport

cd ..

# END AirPlay

# START UPnP

# Headless UPnP Renderer
# Prerequisites
apt-get -y install git automake libglib2.0-dev gstreamer0.10-alsa gstreamer0.10-tools libgstreamer0.10-dev libupnp-dev libxml2-dev gstreamer0.10-ffmpeg gstreamer0.10-plugins-base gstreamer0.10-plugins-good gstreamer0.10-fluendo-mp3 gstreamer0.10-pulseaudio pulseaudio

# Install Headless UPnP Renderer
git clone https://github.com/hzeller/gmrender-resurrect.git
cd gmrender-resurrect
./autogen.sh
./configure LIBS=-lm
make
make install

# Make GStreamer use PulseAudio (for better sound quality)
gconftool-2 -t string --set /system/gstreamer/0.10/default/audiosink pulsesink
gconftool-2 -t string --set /system/gstreamer/0.10/default/audiosrc pulsesrc

# PulseAudio
sed -i -e 's/PULSEAUDIO_SYSTEM_START=0/PULSEAUDIO_SYSTEM_START=1/g' /etc/default/pulseaudio

# Allow Pi & root to use PulseAudio
adduser pi pulse-access
adduser root pulse-access

# Autostart gmediarenderer
cp scripts/init.d/gmediarenderer /etc/init.d/gmediarenderer
chmod 755 /etc/init.d/gmediarenderer
update-rc.d gmediarenderer defaults

# Custom display name
sed -i -e "s/UPNP_DEVICE_NAME=\"Raspberry\"/UPNP_DEVICE_NAME=\"$DISPLAY_NAME\"/g" /etc/init.d/gmediarenderer

# END UPnP

# Change audio output to headphone jack <http://www.raspberrypi.org/documentation/configuration/audio-config.md>
amixer cset numid=3 1

# Make sure the volume is set to 80% to avoid audio popping
amixer sset 'Master' 80%

# Raspberry Pi Volume Control
cp $DIR/lib/vol /usr/local/bin/vol
chmod a+x /usr/local/bin/vol

# All done! Reboot
reboot
