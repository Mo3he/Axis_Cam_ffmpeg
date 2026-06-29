# The ffmpeg installer ACAP

This ACAP packages the scripts and files required to install the ffmpeg server on Axis Cameras.

Current version 2.0.0

### Disclaimer: This is an independent, community-developed ACAP package and is not an official Axis Communications product. It was developed entirely on personal time and is not affiliated with, endorsed by, or supported by Axis Communications AB. Use it at your own risk. For official Axis software, visit axis.com 


## Root not required
As of version 2.0.0 this ACAP no longer needs root. It only ships the static ffmpeg/ffprobe/qt-faststart binaries (packaged world-executable, runMode never), so it is compatible with Axis OS 12+. Other ACAPs can call the binaries directly, e.g. /usr/local/packages/ffmpeg/lib/ffmpeg. This pairs with the go2rtc ACAP, which auto-uses that path for JPEG snapshots and transcoding.

## Purpose

ffmpeg is a complete, cross-platform solution to record, convert and stream audio and video.

## Links

https://ffmpeg.org/

https://www.axis.com/

## Compatibility

The Axis_Cam_ffmpeg is compatable with Axis cameras with arm and aarch64 based Soc's.

```
curl --anyauth "*" -u <username>:<password> <device ip>/axis-cgi/basicdeviceinfo.cgi --data "{\"apiVersion\":\"1.0\",\"context\":\"Client defined request ID\",\"method\":\"getAllProperties\"}"
```

where `<device ip>` is the IP address of the Axis device, `<username>` is the root username and `<password>` is the root password. Please
note that you need to enclose your password with quotes (`'`) if it contains special characters.

## Installing

The recommended way to install this ACAP is to use the prebuilt eap file from the
[Releases](https://github.com/Mo3he/Axis_Cam_ffmpeg/releases) page.
Go to "Apps" on the camera and click "Add app". The app installs Stopped and never
runs (runMode never); it only places the binaries on the device.

## Using the ffmpeg ACAP

The package only stages the binaries; there is nothing to start. They live at:
```
/usr/local/packages/ffmpeg/lib/ffmpeg
/usr/local/packages/ffmpeg/lib/ffprobe
/usr/local/packages/ffmpeg/lib/qt-faststart
```
They are world-executable, so other ACAPs (for example the go2rtc ACAP) can call
them directly, and you can invoke them over ssh:
```
/usr/local/packages/ffmpeg/lib/ffmpeg -h
```
When uninstalling the ACAP, all files are removed from the camera.


## Build from source
To build, 
From main directory of the version you want (arm/aarch64)

```
docker build --tag <package name> . 
```
```
docker cp $(docker create <package name>):/opt/app ./build 
```

## License
The ffmpeg binaries are static builds distributed under the GPL. ffmpeg source
and license: https://ffmpeg.org/. The packaging scripts in this repo are MIT
(see LICENSE).





