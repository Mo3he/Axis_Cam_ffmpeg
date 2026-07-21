# ffmpeg ACAP for Axis Cameras

[![Release](https://img.shields.io/github/v/release/Mo3he/Axis_Cam_ffmpeg?style=flat)](https://github.com/Mo3he/Axis_Cam_ffmpeg/releases)
[![License](https://img.shields.io/github/license/Mo3he/Axis_Cam_ffmpeg?style=flat)](LICENSE)
[![Build](https://github.com/Mo3he/Axis_Cam_ffmpeg/actions/workflows/build.yml/badge.svg)](https://github.com/Mo3he/Axis_Cam_ffmpeg/actions/workflows/build.yml)
[![Super-Linter](https://github.com/Mo3he/Axis_Cam_ffmpeg/actions/workflows/super-linter.yml/badge.svg)](https://github.com/Mo3he/Axis_Cam_ffmpeg/actions/workflows/super-linter.yml)
[![Sponsor](https://img.shields.io/badge/Sponsor%20My%20Work-EA4AAA?style=flat&logo=github&logoColor=white)](https://github.com/sponsors/Mo3he)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/mo3he)

This ACAP packages the scripts and files required to install the ffmpeg binaries
on Axis cameras, so other ACAPs can call `ffmpeg`, `ffprobe`, and `qt-faststart`
directly on the device.

> **Disclaimer:** Independent, community-developed ACAP package. Not an official
> Axis product and not affiliated with, endorsed by, or supported by Axis
> Communications AB or the FFmpeg project. Use at your own risk.

## Overview

ffmpeg is a complete, cross-platform solution to record, convert and stream
audio and video.

As of version 2.0.0 this ACAP no longer needs root. It only ships the static
`ffmpeg`/`ffprobe`/`qt-faststart` binaries (packaged world-executable,
`runMode: never`), so it is compatible with AXIS OS 12+. Other ACAPs can call
the binaries directly, e.g. `/usr/local/packages/ffmpeg/lib/ffmpeg`. This pairs
with the [go2rtc ACAP](https://github.com/Mo3he/Axis_Cam_go2rtc), which
auto-uses that path for JPEG snapshots and transcoding.

## Compatibility

- **AXIS OS:** 11.x through 13.
- **Architectures:** `aarch64` and `armv7hf`.

## Installation

> **Signed packages:** Release `.eap` files are signed with the Axis ACAP
> signing service and install normally on AXIS OS 12.10 and later.
>
> **Upgrading from an earlier version?** The signing vendor changed, so
> installing over a previously installed unsigned build can fail with
> **"Couldn't install: app"** (device log: *"Vendor ID in manifest does not
> match the vendor ID of the previous version"*). To upgrade: back up your app
> configuration, **uninstall** the old version, then install the signed one.

Get the **prebuilt `.eap` file** from the
[Releases page](https://github.com/Mo3he/Axis_Cam_ffmpeg/releases).

1. Log into your Axis camera.
2. Go to **Apps -> Add App**.
3. Upload the `.eap` file.

The app installs Stopped and never runs (`runMode: never`); it only places the
binaries on the device. On uninstall, all files are removed from the camera.

## Configuration

There is nothing to start or configure. The package only stages the binaries,
which live at:

```text
/usr/local/packages/ffmpeg/lib/ffmpeg
/usr/local/packages/ffmpeg/lib/ffprobe
/usr/local/packages/ffmpeg/lib/qt-faststart
```

They are world-executable, so other ACAPs (for example the go2rtc ACAP) can call
them directly, and you can invoke them over ssh:

```sh
/usr/local/packages/ffmpeg/lib/ffmpeg -h
```

## Ports & security

This package opens no network ports and runs no service. It only stages the
ffmpeg binaries on disk for other ACAPs to call locally, so it exposes nothing on
the camera's network interface.

## Build from source

Use the top-level `build.sh` wrapper, which builds the ACAP `.eap` package and
drops it in the repository root:

```sh
./build.sh            # build both aarch64 and armv7hf
./build.sh aarch64    # build a single architecture (aarch64 or armv7hf)
```

It auto-detects `docker` or `podman`; override with `RUNTIME=docker`. To build a
single architecture manually, run the Dockerfile in its subdirectory
(`arm/` or `aarch64/`) directly:

```sh
docker build --tag <package name> aarch64
docker cp $(docker create <package name>):/opt/app ./build
```

## Links

- [FFmpeg](https://ffmpeg.org/)
- [Axis Communications](https://www.axis.com/)

## License

The packaging code in this repository is licensed under BSD 3-Clause (see
[LICENSE](LICENSE)).

The bundled `ffmpeg` and `x264` binaries are built from pinned source and are
distributed under the **GPL-3.0**. ffmpeg source and license: <https://ffmpeg.org/>.
Bundled third-party components are listed in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
