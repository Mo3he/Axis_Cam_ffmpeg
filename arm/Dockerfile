ARG ARCH=armv7hf
ARG VERSION=12.10.0
ARG UBUNTU_VERSION=24.04
ARG REPO=axisecp
ARG SDK=acap-native-sdk

FROM ${REPO}/${SDK}:${VERSION}-${ARCH}-ubuntu${UBUNTU_VERSION}

# ---------------------------------------------------------------------------
# Self-built, camera-focused ffmpeg (GPL-3.0) — armv7hf.
# See aarch64/Dockerfile for the full rationale. Same pins; only the target
# architecture (FFARCH=arm) differs.
#
# Pins (override with --build-arg; keep in sync with THIRD_PARTY_NOTICES.md):
ARG FFMPEG_VERSION=7.1.1
# Official sha256 of ffmpeg-${FFMPEG_VERSION}.tar.xz. REQUIRED for a release build.
ARG FFMPEG_SHA256=733984395e0dbbe5c046abda2dc49a5544e7e0e1e2366bba849222ae9e3a03b1
# Pin x264 to an exact commit for reproducible corresponding source.
ARG X264_COMMIT=b35605ace3ddf7c1a5d67a2eb553f034aef41d55
# ffmpeg configure --arch value for this image.
ARG FFARCH=arm

RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates xz-utils nasm yasm pkg-config make build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# --- x264 (GPL): static, PIC, no CLI --------------------------------------
RUN . /opt/axis/acapsdk/environment-setup* && \
    test -n "${X264_COMMIT}" || { echo "ERROR: set --build-arg X264_COMMIT=<pinned commit>"; exit 1; }; \
    git clone https://code.videolan.org/videolan/x264.git && \
    cd x264 && git checkout "${X264_COMMIT}" && \
    HOST="$(echo "${CROSS_COMPILE}" | sed 's/-$//')" && \
    export AS="${CC}" && \
    ./configure \
        --host="${HOST}" \
        --cross-prefix="${CROSS_COMPILE}" \
        --sysroot="${SDKTARGETSYSROOT}" \
        --prefix=/build/prefix \
        --enable-static --enable-pic \
        --disable-cli --disable-opencl && \
    make -j"$(nproc)" && make install

# --- ffmpeg (GPL-3.0): static, camera-focused -----------------------------
RUN . /opt/axis/acapsdk/environment-setup* && \
    test -n "${FFMPEG_SHA256}" || { echo "ERROR: set --build-arg FFMPEG_SHA256=<official sha256>"; exit 1; }; \
    curl -fsSLO "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" && \
    echo "${FFMPEG_SHA256}  ffmpeg-${FFMPEG_VERSION}.tar.xz" | sha256sum -c - && \
    tar xf "ffmpeg-${FFMPEG_VERSION}.tar.xz" && \
    cd "ffmpeg-${FFMPEG_VERSION}" && \
    PKG_CONFIG_PATH=/build/prefix/lib/pkgconfig \
    ./configure \
        --prefix=/build/out \
        --enable-cross-compile \
        --target-os=linux \
        --arch="${FFARCH}" \
        --cross-prefix="${CROSS_COMPILE}" \
        --sysroot="${SDKTARGETSYSROOT}" \
        --cc="${CC}" --cxx="${CXX}" --ar="${AR}" --nm="${NM}" \
        --ranlib="${RANLIB}" --strip="${STRIP}" --as="${CC}" \
        --host-cc=gcc \
        --pkg-config=pkg-config --pkg-config-flags=--static \
        --extra-cflags="-I/build/prefix/include -O2" \
        --extra-ldflags="-L/build/prefix/lib" \
        --enable-gpl --enable-version3 \
        --enable-libx264 \
        --enable-static --disable-shared \
        --enable-small \
        --disable-debug --disable-doc \
        --disable-ffplay --disable-devices \
        --enable-ffprobe && \
    make -j"$(nproc)" && make install && \
    make tools/qt-faststart

# Building the ACAP application (COPY app first, then overlay built binaries).
COPY ./app /opt/app/
RUN . /opt/axis/acapsdk/environment-setup* && \
    mkdir -p /opt/app/lib && \
    cp /build/out/bin/ffmpeg  /opt/app/lib/ffmpeg && \
    cp /build/out/bin/ffprobe /opt/app/lib/ffprobe && \
    cp /build/ffmpeg-${FFMPEG_VERSION}/tools/qt-faststart /opt/app/lib/qt-faststart && \
    ${STRIP} /opt/app/lib/ffmpeg /opt/app/lib/ffprobe /opt/app/lib/qt-faststart || true
WORKDIR /opt/app
RUN . /opt/axis/acapsdk/environment-setup* && acap-build ./
