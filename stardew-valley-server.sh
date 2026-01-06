#!/bin/bash
#export VNC_PASSWORD=${VNC_PASS}

# Cleanup function
cleanup() {
    echo "Shutting down server..."
    killall -9 StardewModdingAPI Xvfb x11vnc i3 2>/dev/null
    rm -f /tmp/.X10-lock
    exit 0
}

# Trap exit signals
trap cleanup EXIT INT TERM

export XAUTHORITY=~/.Xauthority
export TERM=xterm
export DISPLAY=:10.0

if [ -f /tmp/.X10-lock ]; then rm /tmp/.X10-lock; fi
Xvfb :10 -screen 0 1280x720x24 -ac &

while [ ! -z "`xdpyinfo -display :10 2>&1 | grep 'unable to open display'`" ]; do
  echo Waiting for display;
  sleep 5;
done

x11vnc -display :10 -rfbport 5900 -rfbportv6 -1 -no6 -noipv6 -httpportv6 -1 -forever -ncache 10 -desktop StardewValley -cursor arrow -passwd ${VNC_PASS} -shared &

#sleep 5

cd /mnt/server
./StardewModdingAPI