# The ffmpeg installer ACAP

This ACAP packages the scripts and files required to install the ffmpeg binaries on Axis Cameras.

[![Releases](https://img.shields.io/github/v/release/Mo3he/Axis_Cam_ffmpeg)](https://github.com/Mo3he/Axis_Cam_ffmpeg/releases)  
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%9D%A4-lightgrey?logo=github)](https://github.com/sponsors/Mo3he)  
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support-orange?style=flat&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/mo3he)

> **Disclaimer:** This is an independent, community-developed ACAP package and is not an official Axis Communications product. It is not affiliated with, endorsed by, or supported by Axis Communications AB. Use it at your own risk. For official Axis software, visit axis.com.

---

## Table of Contents

- [Overview](#overview)
- [Compatibility](#compatibility)
- [Installation](#installation)
- [Using the ffmpeg ACAP](#using-the-ffmpeg-acap)
- [Build from Source](#build-from-source)
- [License](#license)

---

## Overview

ffmpeg is a complete, cross-platform solution to record, convert and stream audio and video.

Current version: **2.0.0**

As of version 2.0.0 this ACAP no longer needs root. It only ships the static ffmpeg/ffprobe/qt-faststart binaries (packaged world-executable, runMode never), so it is compatible with Axis OS 12+. It is built on the ACAP Native SDK 12.10.0 with a Manifest Schema v2 (`compatibleOsVersions` up to OS 13), so it is ready for Axis OS 13. Other ACAPs can call the binaries directly, e.g. `/usr/local/packages/ffmpeg/lib/ffmpeg`. This pairs with the go2rtc ACAP, which auto-uses that path for JPEG snapshots and transcoding.

---

## Compatibility

Compatible with Axis cameras with arm and aarch64 based SoCs.

To check your camera architecture:

```
curl --anyauth "*" -u <username>:<password> <device ip>/axis-cgi/basicdeviceinfo.cgi --data "{\"apiVersion\":\"1.0\",\"context\":\"Client defined request ID\",\"method\":\"getAllProperties\"}"
```

---

## Installation

Get the **prebuilt `.eap` file** from the [Releases page](https://github.com/Mo3he/Axis_Cam_ffmpeg/releases).

1. Log into your Axis camera.
2. Go to **Apps -> Add App**.
3. Upload the `.eap` file.

The app installs Stopped and never runs (runMode never); it only places the binaries on the device.

On uninstall, all files are removed from the camera.

---

## Using the ffmpeg ACAP

The package only stages the binaries; there is nothing to start. They live at:

```
/usr/local/packages/ffmpeg/lib/ffmpeg
/usr/local/packages/ffmpeg/lib/ffprobe
/usr/local/packages/ffmpeg/lib/qt-faststart
```

They are world-executable, so other ACAPs (for example the go2rtc ACAP) can call them directly, and you can invoke them over ssh:

```
/usr/local/packages/ffmpeg/lib/ffmpeg -h
```

---

## Build from Source

From the main directory of the version you want (arm/aarch64):

```
docker build --tag <package name> .
```
```
docker cp $(docker create <package name>):/opt/app ./build
```

---

## License

The ffmpeg binaries are built from pinned source (ffmpeg + x264) and are distributed under the GPL. ffmpeg source and license: <https://ffmpeg.org/>. The packaging scripts in this repo are BSD 3-Clause (see [LICENSE](LICENSE)); bundled third-party components are documented in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).





