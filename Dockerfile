# Stage 1: Download static ffmpeg binary and DejaVu fonts using full Alpine
FROM alpine:3.24 AS deps
RUN apk add --no-cache wget xz font-dejavu \
    && wget -q -O /tmp/ff.tar.xz \
       "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz" \
    && tar xJf /tmp/ff.tar.xz -C /tmp/ \
    && find /tmp -maxdepth 3 -name 'ffmpeg' -type f | head -1 | xargs -I{} cp {} /tmp/ffmpeg-bin \
    && find /tmp -maxdepth 3 -name 'ffprobe' -type f | head -1 | xargs -I{} cp {} /tmp/ffprobe-bin \
    && chmod +x /tmp/ffmpeg-bin /tmp/ffprobe-bin

# Stage 2: n8n runtime — copy ffmpeg binary + fonts in (no package manager needed)
FROM n8nio/n8n:latest
USER root
COPY --from=deps /tmp/ffmpeg-bin /usr/local/bin/ffmpeg
COPY --from=deps /tmp/ffprobe-bin /usr/local/bin/ffprobe
COPY --from=deps /usr/share/fonts/dejavu/ /usr/share/fonts/truetype/dejavu/
USER node
