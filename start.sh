#!/usr/bin/env bash

# Start Xvfb on display :99, create a 1024x768x24 screen
Xvfb :99 -screen 0 1024x768x24 &
sleep 1

# Start fluxbox (lightweight window manager)
DISPLAY=:99 fluxbox &
sleep 1

# Start websockify in the background (serving noVNC content on port 8080)
# /usr/share/novnc typically has the noVNC HTML/JS files on Alpine
websockify --web=/usr/share/novnc/ 8080 localhost:5900 &
sleep 1

# Start the VNC server on display :99 (no password, forever)
x11vnc -display :99 -nopw -forever -shared
