#!/bin/bash
# steamcmd Base Installation Script
#
# Server Files: /mnt/server
# Image to install with is 'mono:latest'
apt -y update
apt -y --no-install-recommends install curl lib32gcc-s1 ca-certificates wget unzip libnotify-bin xvfb x11vnc x11-utils i3
apt -y install libnotify-bin xvfb x11vnc x11-utils i3
#apt -y install mono-complete # Needed only if not installing on the modo image ghcr.io/pelican-eggs/yolks:mono_latest

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
    echo -e "Cannot use anonymous login for games that require a license. Please set a user and try again."
    exit 1
else
    echo -e "user set to ${STEAM_USER}"
fi

cd /tmp
mkdir -p /mnt/server/steamcmd

# SteamCMD fails otherwise for some reason, even running as root.
# This is changed at the end of the install process anyways.
chown -R root:root /mnt
export HOME=/mnt/server

## download and install steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

## install game using steamcmd
./steamcmd.sh +force_install_dir /mnt/server +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +app_update ${SRCDS_APPID} validate +quit

## set up 32 bit libraries
mkdir -p /mnt/server/.steam/sdk32
cp -v /mnt/server/steamcmd/linux32/steamclient.so /mnt/server/.steam/sdk32/steamclient.so

## set up 64 bit libraries
mkdir -p /mnt/server/.steam/sdk64
cp -v /mnt/server/steamcmd/linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so

## Game specific setup.
cd /mnt/server/
mkdir -p ./.config
mkdir -p ./.config/i3
mkdir -p ./.config/StardewValley
mkdir -p ./nexus
mkdir -p ./storage
mkdir -p ./logs

## Stardew Valley specific setup.
# wget https://github.com/Pathoschild/SMAPI/releases/download/3.8/SMAPI-3.8.0-installer.zip -qO ./storage/nexus.zip
#wget https://github.com/Pathoschild/SMAPI/releases/download/4.3.2/SMAPI-4.3.2-installer.zip -qO ./storage/nexus.zip
# /bin/bash -c "cd '/mnt/server/nexus/SMAPI 4.3.2 installer/' && printf '2\n1\n1\n\n' | ./install\ on\ Linux.sh"
/bin/bash -c "cd '/mnt/server/nexus/SMAPI 4.3.2 installer/internal/linux/' && printf '2\n1\n1\n' | ./SMAPI.Installer"
unzip ./storage/nexus.zip -d ./nexus/
# /bin/bash -c "echo -e \"2\n/mnt/server\n1\n\" | /usr/bin/mono /mnt/server/nexus/SMAPI\ 3.8.0\ installer/internal/unix-install.exe"
# /bin/bash -c "printf '2\n/mnt/server\n1\n' | /usr/bin/mono '/mnt/server/nexus/SMAPI 3.8.0 installer/internal/unix-install.exe'"
/bin/bash -c "echo -e \"/mnt/server\n1\n\" | /bin/bash '/mnt/server/nexus/SMAPI 4.3.2 installer/install on Linux.sh'"
wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/stardew_valley_server.config -qO ./.config/StardewValley/startup_preferences
#wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/i3.config -qO ./.config/i3/config
wget https://github.com/paytah232/pterodactyl-server-stardew-valley/raw/main/mods/AlwaysOnServer.zip -qO ./storage/AlwaysOnServer.zip
wget https://github.com/paytah232/pterodactyl-server-stardew-valley/raw/main/mods/UnlimitedPlayers.zip -qO ./storage/UnlimitedPlayers.zip
wget https://github.com/paytah232/pterodactyl-server-stardew-valley/raw/main/mods/AutoLoadGame.zip -qO ./storage/AutoLoadGame.zip
wget https://github.com/paytah232/pterodactyl-server-stardew-valley/raw/main/mods/StardewPortChanger.zip -qO ./storage/StardewPortChanger.zip
wget https://github.com/paytah232/pterodactyl-server-stardew-valley/raw/main/mods/AutoHideHost.zip -qO ./storage/AutoHideHost.zip
unzip ./storage/AlwaysOnServer.zip -d ./Mods
unzip ./storage/UnlimitedPlayers.zip -d ./Mods
unzip ./storage/AutoLoadGame.zip -d ./Mods
unzip ./storage/StardewPortChanger.zip -d ./Mods
unzip ./storage/AutoHideHost.zip -d ./Mods
wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/stardew-valley-server.sh -qO ./stardew-valley-server.sh
wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/mods/AutoHideHost.json -qO ./Mods/AutoHideHost/config.json
wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/mods/AutoLoadGame.json -qO ./Mods/AutoLoadGame/config.json
wget https://raw.githubusercontent.com/paytah232/pterodactyl-server-stardew-valley/main/mods/StardewPortChanger.json -qO ./Mods/StardewPortChanger/config.json
chmod +x ./stardew-valley-server.sh 
#rm ./storage/alwayson.zip ./storage/unlimitedplayers.zip ./storage/autoloadgame.zip
# Rename the StardewValley executable to fix server starting conflicts
mv StardewValley StardewValley.exe.bak
echo 'Stardew Valley Installation complete.\nOpen in a VNC view to first create the CO-OP game.\nThen, restart the server, log back in and make sure it loaded the save again.'