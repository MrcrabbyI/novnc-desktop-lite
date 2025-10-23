#!/bin/bash
echo "🚀 Starting Xpra desktop service..."

export DEBIAN_FRONTEND=noninteractive

# 🧱 Ensure apt is ready and dependencies are installed
if ! command -v xpra >/dev/null 2>&1; then
    echo "📦 Installing Xpra, Fluxbox, Chrome, and basic tools..."
    apt-get update && apt-get install -y \
        xpra fluxbox xterm \
        pcmanfm \
        wget gnupg2 curl

    # Install Google Chrome
    if ! command -v google-chrome >/dev/null 2>&1; then
        echo "🌐 Installing Google Chrome..."
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
            > /etc/apt/sources.list.d/google-chrome.list
        apt-get update && apt-get install -y google-chrome-stable
    fi
fi

# 🧹 Kill any existing Xpra sessions to avoid conflicts
pkill -f xpra || true

# 🖱️ Create a Fluxbox menu with shortcuts
mkdir -p ~/.fluxbox
cat > ~/.fluxbox/menu <<EOF
[begin] (Xpra Desktop)
    [exec] (Terminal) {xterm}
    [exec] (File Manager) {pcmanfm}
    [exec] (Google Chrome) {google-chrome --no-sandbox}
    [separator]
    [exit] (Exit)
[end]
EOF

# 🖥️ Start Xpra in background with full web access and no authentication
echo "🚀 Launching Xpra web server..."
nohup xpra start :100 \
  --bind-tcp=0.0.0.0:6080 \
  --html=on \
  --start-child=fluxbox \
  --auth=none \
  --tcp-auth=none \
  --ws-auth=none \
  --mdns=no \
  --daemon=yes \
  --exit-with-children=no \
  > /tmp/xpra.log 2>&1 &

sleep 3
if pgrep xpra >/dev/null; then
  echo "✅ Xpra desktop is live at http://localhost:6080"
else
  echo "❌ Xpra failed to start. Check /tmp/xpra.log for details."
fi
