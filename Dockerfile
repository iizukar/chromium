FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache \
    chromium \
    xvfb \
    tigervnc \
    bash \
    python3 \
    git \
    fluxbox \
    procps  # For process management

# Create non-root user
RUN adduser -D chromiumuser

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && cd /opt/noVNC \
    && git checkout v1.3.0

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Cleanup
RUN rm -rf /var/cache/apk/* /tmp/*

# Switch to non-root user
USER chromiumuser
WORKDIR /home/chromiumuser

EXPOSE 8080
CMD ["/start.sh"]
