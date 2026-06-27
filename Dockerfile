FROM n8nio/n8n:latest
USER root
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg fonts-dejavu-core curl && rm -rf /var/lib/apt/lists/*
USER node
