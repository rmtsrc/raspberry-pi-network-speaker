Raspberry Pi Network Speaker provisioner v0.0.1
==============

What it is
----------
Turns your Raspberry Pi into network speaker supporting Apple AirPlay and UPnP.

How to use it
-------------
Assuming that you've logged into your Raspberry Pi as the default `pi` user and
you've got a speaker plugged into the Pi's audio jack:

```bash
git clone https://github.com/sebflipper/raspberry-pi-network-speaker.git
cd raspberry-pi-network-speaker
sudo ./provision.sh <custom_display_name> # custom_display_name is optional
```

Once completed, the Pi network speaker will appear as `raspberrypi` (or custom
display name) to devices on the same network when using an iPhone/iTunes, using
it as a remote speaker in Mac OS X (`System Preferences` > `Sound` > `Output`),
and connecting to it via any UPnP streamer such as [BubbleUPnP for
Android](https://play.google.com/store/apps/details?id=com.bubblesoft.android.bubbleupnp).

If you find that the volume is too quiet you can login to the Pi and enter
`alsamixer` then use the up and down arrows to adjust the volume
(I'd recommend not going over 90% otherwise the audio starts sounding
distorted).

Tested on
---------
* Raspberry Pi 1 Model B
  * Raspbian February 2015 (2015-02-16)

Tested with
-----------
* [BubbleUPnP for
Android](https://play.google.com/store/apps/details?id=com.bubblesoft.android.bubbleupnp)
* Mac OS X 10.10 Yosemite (as sound output device)
* [Kinsky](http://oss.linn.co.uk/trac/wiki/Kinsky)

Known issues
------------
* AirPlay/ShairPort
  * May need to toggle speaker connection on and off, for it to
    work when the Pi has just booted up
  * Delayed sound start and output

Todo
----
* Support [Google Cast for Audio](http://www.google.com/cast/audio/)

Thanks
------
This provisioner script automates the following guides:
* [Hacking a Raspberry Pi into a wireless airplay speaker](http://jordanburgess.com/post/38986434391/raspberry-pi-airplay)
* [Using a Raspberry Pi with Android phones for media streaming with UPnP / DLNA](http://blog.scphillips.com/2013/01/using-a-raspberry-pi-with-android-phones-for-media-streaming/)

**Software**
* [ShairPort](https://github.com/hendrikw82/shairport)
* [Perl Module : Session Description Protocol](https://github.com/njh/perl-net-sdp)
* [Headless UPnP Renderer](https://github.com/hzeller/gmrender-resurrect)

Changelog
---------
* v0.01 - 2015-02-28
  * initial release
