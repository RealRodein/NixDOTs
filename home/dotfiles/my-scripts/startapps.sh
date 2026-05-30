#!/bin/bash

# 1. Permanent Flatpak Override for Steam (Only needs to be run once, but safe here)
flatpak override --user --env=__NV_PRIME_RENDER_OFFLOAD=1 --env=__GLX_VENDOR_LIBRARY_NAME=nvidia com.valvesoftware.Steam

# 2. Launch Steam (Using Nvidia GPU)
flatpak run com.valvesoftware.Steam &

flatpak run dev.vencord.Vesktop &
# 3. Launch ASUS ROG Control Center
# Note: Ensure 'asusd' service is running (sudo systemctl enable --now asusd)
rog-control-center &

# 4. Launch Twitch Drops Miner (AppImage)
# Use --tray so it doesn't pop up in your face on boot
/home/rodein/Applications/miner/Twitch.AppImage --tray & disown
