# Base image with Mono
FROM ghcr.io/parkervcp/yolks:mono_latest

# Install X11 + VNC + lightweight window manager + utilities
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      xvfb \
      x11vnc \
      i3 \
      x11-utils \
      lib32gcc-s1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory inside container (Pterodactyl default)
WORKDIR /home/container

# Copy your startup script into the container
COPY stardew-valley-server.sh /home/container/stardew-valley-server.sh
RUN chmod +x /home/container/stardew-valley-server.sh

# Default command: run your server script
CMD ["./stardew-valley-server.sh"]
