To build from this directory (armv7hf):

    docker build --tag ffmpeg-acap:armv7hf .
    docker cp $(docker create ffmpeg-acap:armv7hf):/opt/app/ffmpeg_2_0_0_armv7hf.eap .

Prebuilt packages are attached to the GitHub Releases page.
 