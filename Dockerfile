# Use a lightweight Alpine base
FROM alpine:3.18

# Install necessary packages from Alpine repositories
RUN apk --no-cache add \
    chromium \
    xvfb \
    x11vnc \
    fluxbox \
    bash \
    curl \
    unzip \
    python3 \
    py3-pip \
    wget

# Install websockify (Python-based)
RUN pip3 install --no-cache-dir websockify

# Manually download noVNC from GitHub
# (Here we use v1.3.0, but you can pick another stable release tag)
RUN mkdir /noVNC && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz -O /tmp/noVNC.tar.gz && \
    tar xvf /tmp/noVNC.tar.gz -C /noVNC --strip-components=1 && \
    rm /tmp/noVNC.tar.gz

# Copy our startup script into the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 8080 for noVNC
EXPOSE 8080

CMD ["/start.sh"]
