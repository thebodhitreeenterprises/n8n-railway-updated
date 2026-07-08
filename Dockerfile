# Stage 1: full Alpine — install FFmpeg from Alpine repos + collect all shared lib deps
FROM alpine:3.24 AS builder
RUN apk add --no-cache ffmpeg ttf-dejavu \
    && mkdir -p /tmp/out/usr/bin /tmp/out/usr/lib /tmp/out/lib \
    && cp /usr/bin/ffmpeg /usr/bin/ffprobe /tmp/out/usr/bin/ \
    && ldd /usr/bin/ffmpeg /usr/bin/ffprobe 2>/dev/null \
       | awk '{if ($2 == "=>") print $3; else print $1}' \
       | grep -E '^/' | sort -u \
       | while read lib; do \
           [ -f "$lib" ] || continue; \
           dest="/tmp/out$(dirname $lib)"; \
           mkdir -p "$dest"; \
           cp "$lib" "$dest/"; \
         done

# Stage 2: drop binaries + all their shared libs into n8n image
FROM n8nio/n8n:latest
USER root
COPY --from=builder /tmp/out/ /
COPY --from=builder /usr/share/fonts/dejavu/ /usr/share/fonts/truetype/dejavu/
# No USER node — avoids Railway volume permission issues
