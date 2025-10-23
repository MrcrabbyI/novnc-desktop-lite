#!/bin/bash
echo "🚀 Starting Xpra desktop service..."

# Ensure apt is ready
export DEBIAN_FRONTEND=noninteractive

# Install Xpra and Fluxbox if missing
if ! command -v xpra >/dev/null 2>&1; then
    echo "📦 Installing Xpra, Fluxbox, and Xterm..."
    apt-get update && apt-get install -y xpra fluxbox xterm
fi

# Kill any existing Xpra sessions (avoid conflicts)
pkill -f xpra || true

# Start Xpra with web access enabled
xpra start \
    --bind-tcp=0.0.0.0:6080 \
    --html=on \
    --start-child=fluxbox \
    --daemon=no &

echo "✅ Xpra desktop is live at http://localhost:6080"
