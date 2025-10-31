#!/bin/bash
set -e
echo "🚀 Starting Xpra desktop service..."

export DEBIAN_FRONTEND=noninteractive

# 🧱 Ensure dependencies are installed
if ! command -v xpra >/dev/null 2>&1; then
    echo "📦 Installing Xpra, Fluxbox, Chrome, and tools..."
    apt-get update && apt-get install -y \
        xpra fluxbox xterm pcmanfm wget gnupg2 curl mousepad

    # 🌐 Install Google Chrome if missing
    if ! command -v google-chrome >/dev/null 2>&1; then
        echo "🌐 Installing Google Chrome..."
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
            | tee /etc/apt/sources.list.d/google-chrome.list
        apt-get update && apt-get install -y google-chrome-stable
    fi
fi

# 🧹 Kill existing Xpra sessions
pkill -f xpra || true

# 🧰 Configure Fluxbox environment
mkdir -p ~/.fluxbox

# Menu
cat > ~/.fluxbox/menu <<EOF
[begin] (Xpra Desktop)
    [exec] (Terminal) {xterm}
    [exec] (File Manager) {pcmanfm}
    [exec] (Google Chrome) {google-chrome --no-sandbox}
    [exec] (Text Editor) {mousepad}
    [separator]
    [exit] (Exit)
[end]
EOF

# Init config (style + background)
cat > ~/.fluxbox/init <<EOF
session.menuFile: ~/.fluxbox/menu
session.styleFile: /usr/share/fluxbox/styles/bloe
session.screen0.rootCommand: fbsetbg -solid '#2B2B2B'
EOF

# Startup file (autostarts PCManFM for desktop icons)
cat > ~/.fluxbox/startup <<EOF
#!/bin/bash
fbsetbg -solid '#2B2B2B'
pcmanfm --desktop &
exec fluxbox
EOF
chmod +x ~/.fluxbox/startup

# 🖥️ Start Xpra web desktop (no auth)
echo "🚀 Launching Xpra web server..."
xpra start :100 \
  --bind-tcp=0.0.0.0:6080 \
  --html=on \
  --start-child="bash -c '$HOME/.fluxbox/startup'" \
  --tcp-auth=none \
  --mdns=no \
  --no-daemon \
  --exit-with-children=yes \
  --ssl=off \
  --sharing=yes \
  --notifications=no \
  --bell=no \
  --clipboard=yes \
  --printing=no \
  --dbus=no \
  --systemd-run=no

echo "✅ Xpra desktop ready at http://localhost:6080"
echo "💡 Right-click the background for Fluxbox menu."
