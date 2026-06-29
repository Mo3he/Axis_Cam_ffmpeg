To build from this directory (aarch64):

    docker build --tag ffmpeg-acap:aarch64 .
    docker cp $(docker create ffmpeg-acap:aarch64):/opt/app/ffmpeg_2_0_0_aarch64.eap .

Prebuilt packages are attached to the GitHub Releases page.
 