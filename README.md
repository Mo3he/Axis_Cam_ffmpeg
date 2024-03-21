# The ffmpeg installer ACAP

This ACAP packages the scripts and files required to install the ffmpeg server on Axis Cameras.

Current version 1.0.0


## Warning
Unfortunately Axis is making changes to its firmware that will prevent the use of a lot of ACAPs including my own and as of today there is no way to ready my ACAPs for these changes.
 
You can read more here
 
https://help.axis.com/en-us/axis-os#upcoming-breaking-changes

If you have a use case where certain functionality used by an ACAP application currently requires root-user permissions or have a question about ACAP application signing, please contact Axis at acap-privileges@axis.com

Thank you for your continued support.

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

The recommended way to install this ACAP is to use the pre built eap file.
Go to "Apps" on the camera and click "Add app".


## Using the ffmpeg ACAP

The ffmpeg ACAP will run a script on startup that sets the required permissions.
Once started click "Open" to see the output of the logs.

Further commands can then be issues via ssh.

For example
```
/usr/local/packages/ffmpeg/lib/ffmpeg -h
```

When uninstalling the ACAP, all changes and files are removed from the camera.


## Build from source
To build, 
From main directory of the version you want (arm/aarch64)

```
docker build --tag <package name> . 
```
```
docker cp $(docker create <package name>):/opt/app ./build 
```





