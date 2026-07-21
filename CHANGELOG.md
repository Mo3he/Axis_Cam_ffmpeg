# Changelog

All notable changes to this project are documented here. Each version
links to its full release notes on GitHub.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

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

[2.0.0-2]: https://github.com/Mo3he/Axis_Cam_ffmpeg/releases/tag/v2.0.0-2
[2.0.0]: https://github.com/Mo3he/Axis_Cam_ffmpeg/releases/tag/v2.0.0
