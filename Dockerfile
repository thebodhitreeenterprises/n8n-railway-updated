FROM n8nio/n8n:latest
USER root
# n8n base image (Alpine 3.24) has apk-tools removed, so use static ffmpeg binary
# curl, ca-certificates, and busybox are available in the base image
RUN curl -fsSL https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz \
    | tar -xJ --strip-components=2 -C /usr/local/bin/ --wildcards '*/bin/ffmpeg' '*/bin/ffprobe' \
    && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
USER node
