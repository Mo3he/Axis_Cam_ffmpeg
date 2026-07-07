# Third-Party Notices

This package distributes **FFmpeg** binaries built from source by this
repository (see `aarch64/Dockerfile` and `arm/Dockerfile`). The ACAP packaging
and build tooling is licensed separately (see `LICENSE`); the FFmpeg binaries
are licensed under the GPL as described below.

## FFmpeg (bundled binaries: `ffmpeg`, `ffprobe`, `qt-faststart`)

- Project: https://ffmpeg.org/
- Version: **7.1.1** (pinned; `FFMPEG_VERSION` in the Dockerfiles)
- Source: https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz
  (sha256 `733984395e0dbbe5c046abda2dc49a5544e7e0e1e2366bba849222ae9e3a03b1`,
  verified at build time)
- License: **GNU General Public License, version 3 (GPL-3.0)** — configured with
  `--enable-gpl --enable-version3`.

### Statically linked GPL library

- **x264** (H.264 encoder) — https://code.videolan.org/videolan/x264
  - License: **GPL-2.0-or-later**
  - Pinned commit: `b35605ace3ddf7c1a5d67a2eb553f034aef41d55`
    (`X264_COMMIT` in the Dockerfiles)

Because x264 (GPL) is statically linked, the combined FFmpeg binary is
distributed under the GPL-3.0. All other codecs (MJPEG/JPEG, AAC, and common
demuxers/muxers/filters) are FFmpeg's own built-in implementations. This is a
deliberately reduced, camera-focused build; it does not include the wider codec
set of general-purpose FFmpeg distributions.

> FFmpeg is invoked as a standalone executable by other applications; it is not
> linked into this repository's packaging code. The packaging code therefore
> remains under its own license, while the FFmpeg **binaries** are under GPL-3.0.

## GPL-3.0 corresponding source

The complete corresponding source for these binaries is fully described by this
repository: the pinned FFmpeg release (with verified sha256) and the pinned
x264 commit are fetched and compiled by `aarch64/Dockerfile` / `arm/Dockerfile`.
Anyone can reproduce the exact binaries with, e.g.:

```
container build --platform linux/amd64 -t ffmpeg-acap-aarch64 aarch64/   # or arm/
```

No separate source mirror or written offer is required: the source and the exact
build recipe (compiler flags, versions, configure options) are present in this
repository.

## GPL-3.0 license text

The full text of the GNU General Public License version 3 is available at
https://www.gnu.org/licenses/gpl-3.0.txt and should ship in this repository so it
is distributed alongside the binaries.
