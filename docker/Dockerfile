# Base image
FROM debian:bookworm-slim

# Install Mono runtime + VNC + X11 + utilities
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      mono-runtime \
      mono-devel \
      ca-certificates-mono \
      xvfb \
      x11vnc \
      i3 \
      x11-utils \
      wget unzip lib32gcc-s1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory (Pterodactyl default)
WORKDIR /home/container

# Copy Stardew startup script
COPY stardew-valley-server.sh /home/container/stardew-valley-server.sh
RUN chmod +x /home/container/stardew-valley-server.sh

# Default command
CMD ["./stardew-valley-server.sh"]
