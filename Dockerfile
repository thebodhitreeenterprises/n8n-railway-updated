FROM n8nio/n8n:latest
USER root
 
# Install wget + fonts, then pull FFmpeg from BtbN (Alpine-compatible: no curl, no --wildcards)
RUN apk add --no-cache wget ttf-dejavu \
    && wget -qO /tmp/ff.tar.xz \
        "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz" \
    && tar -xJf /tmp/ff.tar.xz \
        --strip-components=2 \
        -C /usr/local/bin \
        ffmpeg-master-latest-linux64-gpl/bin/ffmpeg \
        ffmpeg-master-latest-linux64-gpl/bin/ffprobe \
    && rm /tmp/ff.tar.xz \
    && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
 
# No USER node — keeps root to avoid Railway volume permission issues
 

