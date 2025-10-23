#!/bin/bash
# Auto-run XPRA desktop after Codespace starts

# Ensure permissions (so you don’t have to rerun chmod)
chmod +x .devcontainer/postStartCommand.sh

echo "Starting Xpra desktop service..."
if command -v xpra >/dev/null 2>&1; then
    xpra start --bind-tcp=0.0.0.0:6080 --html=on \
        --start-child=startfluxbox \
        --start-child=google-chrome-stable \
        --start-child=pcmanfm \
        --daemon=no &
    echo "Xpra desktop started on port 6080"
else
    echo "Xpra not found! Is the container using xpra-desktop feature?"
fi
