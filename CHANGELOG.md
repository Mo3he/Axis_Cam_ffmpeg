# Changelog

All notable changes to this project are documented here. Each version
links to its full release notes on GitHub.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## 9.0.1 - 2026-08-24

- Update to upstream 9.0.1.
- **Added HTTPS/TLS support** (`--enable-openssl`). `https://` and `rtmps://`
  URLs now work; previously any TLS URL failed with "Protocol not found".
  OpenSSL is linked dynamically against the copy that ships with AXIS OS, so
  the package size is essentially unchanged.
- **Restored the `lavfi` input device** (`--enable-indev=lavfi`), so the common
  `-f lavfi -i anullsrc` idiom works instead of failing with
  "Unknown input format: 'lavfi'".
- Corrected `THIRD_PARTY_NOTICES.md`, which still referenced FFmpeg 7.1.1.

## [2.0.1] - 2026-07-24 - go2rtc compatibility fix

- Fixed the bundled `ffmpeg` linking against the Axis SDK's stripped-down system
  `libav*` libraries (which lack the RTSP muxer and libopus). The binary now
  links its own static libraries, so go2rtc's `-f rtsp` piping works instead of
  failing with "Requested output format 'rtsp' is not known" (exit 183).
- Added **libopus 1.5.2** and enabled `--enable-libopus` so go2rtc's
  `#audio=opus` audio transcoding (WebRTC) works.
- Enabled `--enable-network` explicitly.

## [2.0.0-Signed] - 2026-07-21 - FFmpeg 2.0.0 (Signed)

- Packages are now signed with the Axis ACAP signing service and install
  normally on AXIS OS 12.10 and later.
- Vendor updated to `moshe@mohome.net` with the registered vendor ID.
- Upgrading from an earlier unsigned version can fail with "Couldn't
  install: app" (device log: "Vendor ID in manifest does not match the
  vendor ID of the previous version"). Back up your config, uninstall the
  old version, then install this one.

## [2.0.0-2] - 2026-07-07 - (Axis OS 13 ready)

## [2.0.0] - 2026-06-29 - non-root ffmpeg ACAP

[2.0.1]: https://github.com/Mo3he/Axis_Cam_ffmpeg/releases/tag/v2.0.1
[2.0.0-2]: https://github.com/Mo3he/Axis_Cam_ffmpeg/releases/tag/v2.0.0-2
[2.0.0]: https://github.com/Mo3he/Axis_Cam_ffmpeg/releases/tag/v2.0.0
