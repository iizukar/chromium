#!/bin/bash

# Set display
export DISPLAY=:1

# Start Xvfb
Xvfb :1 -screen 0 1280x720x16 &

# Set VNC password (change "password" to your secure password)
mkdir -p ~/.vnc
echo -e "password\npassword\nn" | vncpasswd
chmod 600 ~/.vnc/passwd

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 16 -localhost no \
  -xstartup /usr/bin/xterm &

# Start noVNC proxy
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:8080 &

# Start Chromium
chromium-browser --no-sandbox --disable-gpu \
  --display=$DISPLAY \
  --no-first-run --start-maximized \
  --window-size=1280,720
