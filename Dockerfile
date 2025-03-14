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
    procps \
    dbus \
    ttf-freefont \
    xauth \
    && mkdir -p /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix

# Create non-root user
RUN adduser -D -h /home/chromiumuser chromiumuser \
    && chown -R chromiumuser:chromiumuser /home/chromiumuser

# Clone noVNC with proper permissions
RUN git clone https://github.com/novnc/noVNC.git /home/chromiumuser/noVNC \
    && cd /home/chromiumuser/noVNC \
    && git checkout v1.3.0 \
    && chown -R chromiumuser:chromiumuser /home/chromiumuser/noVNC

# Install websockify separately
RUN git clone https://github.com/novnc/websockify.git /home/chromiumuser/noVNC/utils/websockify \
    && cd /home/chromiumuser/noVNC/utils/websockify \
    && git checkout v0.11.0 \
    && chown -R chromiumuser:chromiumuser /home/chromiumuser/noVNC

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
