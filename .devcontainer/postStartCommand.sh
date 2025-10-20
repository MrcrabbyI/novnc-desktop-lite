#!/bin/bash
# Auto-run desktop-lite after Codespace starts

# Ensure permissions
chmod +x .devcontainer/desktop-lite

# Start VNC and web interface
sudo .devcontainer/desktop-lite/start.sh || sudo .devcontainer/desktop-lite/install.sh
