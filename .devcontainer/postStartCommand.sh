#!/usr/bin/env bash
set -e

echo "🔁 postStartCommand: Restarting VNC + noVNC..."

# Kill old processes if they exist
pkill -f vncserver || true
pkill -f websockify || true

# Restart VNC server (:1 = display 1)
vncserver -kill :1 || true
vncserver :1 -geometry 1280x800 -depth 24

# Start noVNC/websockify
websockify --web=/usr/share/novnc/ 6080 localhost:5901 --daemon

echo "✅ Desktop environment is ready!"
echo "🌐 Open: http://localhost:6080"
