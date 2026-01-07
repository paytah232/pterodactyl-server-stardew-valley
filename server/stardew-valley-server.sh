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

# Start virtual display
if [ -f /tmp/.X10-lock ]; then rm /tmp/.X10-lock; fi
Xvfb :10 -screen 0 1280x720x24 -ac &

# Wait for X display
while ! xdpyinfo -display :10 >/dev/null 2>&1; do
    echo "Waiting for X display..."
    sleep 2
done

# Start VNC if enabled
if [ "${USE_VNC}" = "1" ]; then

    echo "Starting x11vnc on port ${VNC_PORT}"

    # Start VNC server
    x11vnc -display :10 -rfbport "${VNC_PORT:-5900}" -ncache 10 -forever -shared -passwd "${VNC_PASS:-myvncpassword}" &
else
    echo "VNC mode disabled"
fi

# Approximate render throttling via timer slack
# RENDER_FPS < 30  -> apply timerslack
# RENDER_FPS >= 30 -> no throttling (full speed)

FPS="${RENDER_FPS:-30}"

# Validate integer
case "$FPS" in
  ''|*[!0-9]*)
    echo "Invalid RENDER_FPS='$FPS'; skipping render throttle"
    FPS=30
    ;;
esac

if [ "$FPS" -lt 30 ]; then
  SLACK_NS=$(( 1000000000 / FPS ))

  if [ -w /proc/self/timerslack_ns ]; then
    echo "$SLACK_NS" > /proc/self/timerslack_ns
    echo "Render throttle enabled: ~${FPS}Hz (timerslack_ns=$SLACK_NS)"
  else
    echo "timerslack_ns not available; cannot apply render throttle"
  fi
else
  echo "RENDER_FPS=$FPS (>=30): render throttle disabled (full speed)"
fi

# Start Stardew server
cd /home/container
exec ./StardewModdingAPI