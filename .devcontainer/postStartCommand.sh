#!/bin/bash
echo "Starting Xpra desktop service..."

if ! command -v xpra >/dev/null 2>&1; then
    echo "Installing Xpra..."
    apt update && apt install -y xpra fluxbox xterm
fi

xpra start --bind-tcp=0.0.0.0:6080 --html=on --start-child=startfluxbox --daemon=no &
echo "✅ Xpra desktop started on port 6080"
