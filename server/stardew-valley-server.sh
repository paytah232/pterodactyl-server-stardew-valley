#!/bin/bash
export DISPLAY=:10.0
export XAUTHORITY=~/.Xauthority
export TERM=xterm

# Cleanup function
cleanup() {
    echo "Shutting down server..."
    killall -9 StardewModdingAPI Xvfb x11vnc i3 2>/dev/null
    rm -f /tmp/.X10-lock
}
trap cleanup EXIT INT TERM

# Start virtual display if VNC is enabled
if [ "${USE_VNC}" = "1" ]; then
    
    echo "VNC mode enabled: starting Xvfb..."
    if [ -f /tmp/.X10-lock ]; then rm /tmp/.X10-lock; fi
    Xvfb :10 -screen 0 1280x720x24 -ac &

    # Wait for X display
    while ! xdpyinfo -display :10 >/dev/null 2>&1; do
        echo "Waiting for X display..."
        sleep 2
    done

    echo "Starting x11vnc on port ${VNC_PORT}"

    # Start VNC server
    x11vnc -display :10 -rfbport "${VNC_PORT:-5900}" -ncache 10 -forever -shared -passwd "${VNC_PASS:-myvncpassword}" &
else
    echo "VNC mode disabled: skipping Xvfb/i3/x11vnc."
fi

# Start Stardew server
cd /home/container
exec ./StardewModdingAPI