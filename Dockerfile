# Use a minimal base image
FROM debian:bullseye-slim

# Install dependencies: include ca-certificates, git, and other required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    git \
    xvfb \
    fluxbox \
    x11vnc \
    unzip \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN wget -O /tmp/noVNC.zip https://github.com/novnc/noVNC/archive/v1.3.0.zip \
    && unzip /tmp/noVNC.zip -d /opt/ \
    && mv /opt/noVNC-1.3.0 /opt/noVNC \
    && rm /tmp/noVNC.zip

# Configure fluxbox menu to include a Chromium launcher
RUN mkdir -p /root/.fluxbox && echo "\
[begin] (Fluxbox)\n\
  [exec] (Launch Chromium) {chromium}\n\
[separator]\n\
  [exit] (Exit)\n\
[end]" > /root/.fluxbox/menu

# Expose the noVNC port (default is 6080)
EXPOSE 6080

# Set the DISPLAY environment variable for all processes
ENV DISPLAY=:99

# Start all services with a delay to ensure Xvfb is ready
CMD Xvfb :99 -screen 0 1280x720x24 & \
    fluxbox & \
    x11vnc -display :99 -forever -nopw -listen 0.0.0.0 -xkb & \
    sleep 5 && /opt/noVNC/utils/novnc_proxy --vnc localhost:5900
