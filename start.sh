#!/bin/bash

# VNC configuration
mkdir -p ~/.vnc
echo -e "mypassword\nmypassword\nn" | vncpasswd
chmod 600 ~/.vnc/passwd

# Start X virtual framebuffer
Xvfb :1 -screen 0 1280x720x16 +extension RANDR +extension GLX &
export DISPLAY=:1

# Start window manager
fluxbox &

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 16 -localhost no \
  -xstartup /usr/bin/startfluxbox &

# Start noVNC proxy
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:8080 &

# Start Chromium with security flags
chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --disable-features=AdjustOOMScore \
  --disable-oom-kill-denial \
  --no-zygote \
  --disable-software-rasterizer \
  --display=$DISPLAY \
  --no-first-run \
  --start-maximized \
  --window-size=1280,720 \
  --remote-debugging-port=9222
