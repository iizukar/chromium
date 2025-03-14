FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache \
    chromium \
    xvfb \
    tightvncserver \
    bash \
    python3 \
    git

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && cd /opt/noVNC \
    && git checkout v1.3.0

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Cleanup to reduce image size
RUN rm -rf /var/cache/apk/* /tmp/*

EXPOSE 8080
CMD ["/start.sh"]
