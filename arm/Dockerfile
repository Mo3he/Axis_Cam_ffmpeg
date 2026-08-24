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
ARG FFMPEG_VERSION=9.0.1
# Official sha256 of ffmpeg-${FFMPEG_VERSION}.tar.xz. REQUIRED for a release build.
ARG FFMPEG_SHA256=cf38e0e28c7e5605942c4a77755349b0145804a397af37eb1fb4c77cb237f635
# Pin x264 to an exact commit for reproducible corresponding source.
ARG X264_COMMIT=b35605ace3ddf7c1a5d67a2eb553f034aef41d55
# libopus (BSD): required by go2rtc for #audio=opus (WebRTC audio).
ARG OPUS_VERSION=1.5.2
ARG OPUS_SHA256=65c1d2f78b9f2fb20082c38cbe47c951ad5839345876e46941612ee87f9a7ce1
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

# --- libopus (BSD): static, PIC -------------------------------------------
RUN . /opt/axis/acapsdk/environment-setup* && \
    test -n "${OPUS_SHA256}" || { echo "ERROR: set --build-arg OPUS_SHA256=<official sha256>"; exit 1; }; \
    curl -fsSLO "https://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz" && \
    echo "${OPUS_SHA256}  opus-${OPUS_VERSION}.tar.gz" | sha256sum -c - && \
    tar xf "opus-${OPUS_VERSION}.tar.gz" && \
    cd "opus-${OPUS_VERSION}" && \
    HOST="$(echo "${CROSS_COMPILE}" | sed 's/-$//')" && \
    ./configure \
        --host="${HOST}" \
        --prefix=/build/prefix \
        --enable-static --disable-shared --with-pic \
        --disable-doc --disable-extra-programs && \
    make -j"$(nproc)" && make install

# The Axis SDK sysroot ships a stripped-down system FFmpeg 8.0 (built with
# --disable-everything: no RTSP muxer, no libopus). If those shared libraries
# stay in the sysroot the linker binds our ffmpeg to them and the binary loads
# the crippled system libav* at runtime, so go2rtc fails with
# "Requested output format 'rtsp' is not known". Remove them so our own static
# libraries are linked instead.
RUN . /opt/axis/acapsdk/environment-setup* && \
    for l in avutil avcodec avformat avfilter avdevice swscale swresample postproc; do \
        rm -f "${SDKTARGETSYSROOT}/usr/lib/lib${l}".so*; \
        rm -f "${SDKTARGETSYSROOT}/usr/lib/pkgconfig/lib${l}.pc"; \
    done

# --- ffmpeg (GPL-3.0): static, camera-focused -----------------------------
RUN . /opt/axis/acapsdk/environment-setup* && \
    test -n "${FFMPEG_SHA256}" || { echo "ERROR: set --build-arg FFMPEG_SHA256=<official sha256>"; exit 1; }; \
    curl -fsSLO "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" && \
    echo "${FFMPEG_SHA256}  ffmpeg-${FFMPEG_VERSION}.tar.xz" | sha256sum -c - && \
    tar xf "ffmpeg-${FFMPEG_VERSION}.tar.xz" && \
    cd "ffmpeg-${FFMPEG_VERSION}" && \
    PKG_CONFIG_PATH="/build/prefix/lib/pkgconfig:${PKG_CONFIG_PATH}" \
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
        --extra-cflags="-I/build/prefix/include -I/build/prefix/include/opus -O2" \
        --extra-ldflags="-L/build/prefix/lib" \
        --enable-gpl --enable-version3 \
        --enable-libx264 \
        --enable-libopus \
        --enable-network \
        --enable-openssl \
        --enable-static --disable-shared \
        --enable-small \
        --disable-debug --disable-doc \
        --disable-ffplay \
        --disable-devices --enable-indev=lavfi \
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
