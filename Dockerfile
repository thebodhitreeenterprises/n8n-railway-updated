# Stage 1: Download truly-static ffmpeg (John Van Sickle — musl/Alpine compatible)
FROM alpine:3.24 AS deps
RUN apk add --no-cache wget xz font-dejavu \
    && wget -q -O /tmp/ff.tar.xz \
       "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" \
    && tar xJf /tmp/ff.tar.xz -C /tmp/ \
    && find /tmp -maxdepth 2 -name 'ffmpeg' -type f | head -1 | xargs -I{} cp {} /tmp/ffmpeg-bin \
    && find /tmp -maxdepth 2 -name 'ffprobe' -type f | head -1 | xargs -I{} cp {} /tmp/ffprobe-bin \
    && chmod +x /tmp/ffmpeg-bin /tmp/ffprobe-bin

# Stage 2: n8n runtime — add ffmpeg + DejaVu fonts
FROM n8nio/n8n:latest
USER root
COPY --from=deps /tmp/ffmpeg-bin /usr/local/bin/ffmpeg
COPY --from=deps /tmp/ffprobe-bin /usr/local/bin/ffprobe
COPY --from=deps /usr/share/fonts/dejavu/ /usr/share/fonts/truetype/dejavu/
# No USER node: run as root to avoid volume permission issues on Railway
