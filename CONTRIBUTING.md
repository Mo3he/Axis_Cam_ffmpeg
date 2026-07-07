# Contributing

Thanks for helping improve this ACAP. Bug reports, fixes, features, and docs are
all welcome.

## Reporting issues

- Bugs and feature requests: open a GitHub issue and include your camera model,
  Axis OS version, the app version (or `.eap` filename), and steps to reproduce.
- Security vulnerabilities: please do not open a public issue; follow
  `SECURITY.md`.

## Building

The FFmpeg binaries are compiled from pinned source (see `THIRD_PARTY_NOTICES.md`)
by the per-architecture Dockerfiles. Each architecture builds from its own
directory using the Axis ACAP Native SDK image. Docker (or Apple `container`)
must be installed. For example, aarch64:

```sh
cd aarch64                 # or arm/ for armv7hf
docker build --tag ffmpeg-acap .
docker cp "$(docker create ffmpeg-acap)":/opt/app ./build   # extract the .eap
```

The pinned FFmpeg and x264 versions are `ARG`s at the top of each Dockerfile.
Install the resulting `.eap` on a camera under **Apps > Add app**. Because this
is a binary provider (`runMode: never`), verify by calling the binary from
another ACAP or over SSH, e.g. `/usr/local/packages/ffmpeg/lib/ffmpeg -version`.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one logical change.
3. Build both architectures locally before submitting.
4. If you change the FFmpeg/x264 versions or configure flags, update
   `THIRD_PARTY_NOTICES.md` to match.
5. Explain what the change does and why in the description.

## Code style

- Keep Markdown lint-clean (`.markdownlint.yaml`): wrap bare URLs and emails in
  angle brackets and give code fences a language.
- Match the surrounding code and keep diffs minimal.

## Licensing

By contributing, you agree that your contributions to the ACAP packaging are
licensed under this repository's `LICENSE` (BSD 3-Clause). The bundled FFmpeg
binaries remain under the GPL-3.0 (see `THIRD_PARTY_NOTICES.md`). This is an
independent, community project and is not affiliated with or endorsed by Axis
Communications.
