# Stardew Valley Pterodactyl Server

This repository provides the files and scripts needed to run a **Stardew Valley multiplayer server** inside a Pterodactyl instance. It includes setup scripts, mod management, and optional VNC access for GUI setup.

It was an attempt at many things, hugely supported by ChatGPT and Claude on the way. As such, I don't expect it to be optimised, and probably too many things are installed etc, but it worked for me. If you know how to improve it, feel free!

---

## Overview

- Runs Stardew Valley multiplayer server on Pterodactyl.
- Supports optional VNC for GUI-based configuration.
- Includes scripts to install and configure commonly used mods.
- Tested with **Stardew Valley v1.6.15**.

---

## Requirements

- **Pterodactyl Panel** and **Daemon** installed on your host.
- A valid **Steam account** with a license for Stardew Valley.
- Optional: VNC client if you want to access the server GUI.

---

## Installation

1. **Import the Egg** into your Pterodactyl panel.
2. **Create a new server** using the imported egg.
3. **Set the environment variables** in the panel (see below).
4. **Start the server**. Installation scripts will download and configure the server and optional mods.
5. First time installation, you'll need to access via VNC to set up a new save (then you can turn VNC off). If the scaling is off, a server restart seems to fix it.
 * Some helpful information further I followed [here](https://github.com/DaanSelen/stardew-multiplayer), but essentially:
  * Log in via VNC Viewer
  * In Menus: CO-OP -> Host -> Settings -> Start. Reboot to see if it auto loads in, and you're golden.

---

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `STEAM_USERNAME` | Steam login for downloading the server | `myusername` |
| `STEAM_PASSWORD` | Steam password or token | `mypassword` |
| `VNC_PORT` | Port for VNC access (optional) | `5900` |
| `VNC_PASS` | VNC password (optional) | `myvncpassword` |
| `USE_VNC` | Enable VNC (1 = enabled, 0 = disabled) | `1` |
| `RENDER_FPS` | (Experimental) Set to below 30 FPS to limit the host render fps (try 5) which massively reduces CPU usage. Not sure how this will affect the in game actions... | `1` |

---

## Mods and Configuration

- Mods are managed under the `Mods/` folder.
- Each mod may include its own configuration file. For example:

```text
Mods/UnlimitedPlayers/config.json
```

- The server supports **dynamic configuration** using Pterodactyl’s egg variables. You can set values such as player limits or passwords without editing files manually.

> **Important:** Third-party mods are **licensed by their original authors**. This repository does **not** claim ownership of any third-party mod. Always check the mod’s license before distributing.

---

## Usage

- Connect using the **standard Stardew Valley client**.
- Back up save files and mod configurations regularly to avoid data loss.

---

## Optional VNC Access

If VNC is enabled (`USE_VNC=1`):

- Access it using a VNC client with:
  - **Host:** `<server-ip>`
  - **Port:** `${VNC_PORT}`
  - **Password:** `${VNC_PASS}`

This allows you to run mods or configure the server via GUI if needed.

---

## Notes

- Make sure required **ports are forwarded** on the host for multiplayer connectivity.

---

## License

- **Scripts and configuration files authored by me:** [The Unlicense](http://unlicense.org/) – free to use, modify, or distribute.
- **Third-party mods and assets:** Remain under their **original authors’ licenses**. Refer to each mod’s original documentation for terms of use.
- This software is provided “as-is” **without warranty**.

---

## Contributing

- Feel free to change whatever you like. This was a bit of a passion project to help some friends run a server, but I don't expect to actively maintain it unless it hurts our own gameplay.

---

