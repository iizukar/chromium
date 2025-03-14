#!/bin/bash

# Create X authority file
touch ~/.Xauthority
xauth generate :1 . trusted

# Generate Fluxbox config
mkdir -p ~/.fluxbox
echo "[session] (fluxbox)" > ~/.fluxbox/init
echo "[begin] (fluxbox)" >> ~/.fluxbox/init
echo "[end]" >> ~/.fluxbox/init

# VNC configuration
mkdir -p ~/.vnc
echo -e "mypassword\nmypassword\nn" | vncpasswd
chmod 600 ~/.vnc/passwd

# Start DBus
sudo mkdir -p /var/run/dbus
sudo dbus-daemon --system --fork

# Start X virtual framebuffer
Xvfb :1 -screen 0 1280x720x16 +extension RANDR +extension GLX &
export DISPLAY=:1

# Start Fluxbox
fluxbox &

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 16 -localhost no \
  -xstartup /usr/bin/startfluxbox &

# Start noVNC proxy
/home/chromiumuser/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:8080 &

# Start Chromium with security flags
chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --disable-features=AdjustOOMScore,Translate,BlinkGenPropertyTrees \
  --disable-oom-kill-denial \
  --no-zygote \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --display=$DISPLAY \
  --no-first-run \
  --start-maximized \
  --window-size=1280,720 \
  --remote-debugging-port=9222
