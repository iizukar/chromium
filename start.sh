#!/usr/bin/env bash

# Start virtual X server on display :99 (1024x768x24bpp)
Xvfb :99 -screen 0 1024x768x24 &
sleep 2

# Start fluxbox (lightweight window manager)
DISPLAY=:99 fluxbox &
sleep 2

# Start websockify in the background
# Serves noVNC (HTML/JS) from /noVNC on port 8080, bridging VNC at 5900
websockify -D --web=/noVNC 0.0.0.0:8080 localhost:5900
sleep 1

# Finally, start the VNC server on display :99
# -nopw   -> no password
# -forever -> never exit
# -shared -> allow multiple clients
x11vnc -display :99 -nopw -forever -shared
