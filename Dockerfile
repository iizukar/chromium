FROM alpine:3.18

# Install dependencies with corrected package names
RUN apk add --no-cache \
    chromium \
    xvfb \
    tigervnc \
    bash \
    python3 \
    git \
    fluxbox  # Window manager for better UX

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
