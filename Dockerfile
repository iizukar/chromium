# Use a lightweight Alpine base image
FROM alpine:3.18

# Install necessary packages:
#  - chromium: the Chromium browser
#  - xvfb: X server in virtual framebuffer mode
#  - x11vnc: VNC server
#  - fluxbox: a small and fast window manager
#  - noVNC + websockify: to serve VNC over a web socket
#  - bash, curl, unzip: basic tools
RUN apk --no-cache add \
    chromium \
    xvfb \
    x11vnc \
    fluxbox \
    noVNC \
    websockify \
    bash \
    curl \
    unzip

# Copy our startup script into the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 8080 (where we’ll serve noVNC)
EXPOSE 8080

CMD ["/start.sh"]
