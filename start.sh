#!/usr/bin/env bash

# Start virtual X server on display :99 (1024x768x24bpp)
Xvfb :99 -screen 0 1024x768x24 &
sleep 2

# Start fluxbox (lightweight window manager)
DISPLAY=:99 fluxbox &
sleep 2

# Launch Chromium with recommended flags for Alpine in a container
DISPLAY=:99 chromium \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --disable-software-rasterizer \
  --disable-seccomp-filter-sandbox \
  --disable-setuid-sandbox \
  &

# Start websockify in the background, serving noVNC on port 8080
websockify -D --web=/noVNC 0.0.0.0:8080 localhost:5900
sleep 1

# Start the VNC server on display :99
x11vnc -display :99 -nopw -forever -shared
