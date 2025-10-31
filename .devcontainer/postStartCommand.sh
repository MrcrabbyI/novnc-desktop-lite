#!/bin/bash
set -e
echo "🚀 Starting Xpra desktop service..."

export DEBIAN_FRONTEND=noninteractive

# 🧱 Ensure dependencies are installed
if ! command -v xpra >/dev/null 2>&1; then
    echo "📦 Installing Xpra, Fluxbox, Chrome, and tools..."
    apt-get update && apt-get install -y \
        xpra fluxbox xterm pcmanfm wget gnupg2 curl mousepad fbsetbg

    # 🌐 Install Google Chrome if missing
    if ! command -v google-chrome >/dev/null 2>&1; then
        echo "🌐 Installing Google Chrome..."
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
            | tee /etc/apt/sources.list.d/google-chrome.list
        apt-get update && apt-get install -y google-chrome-stable
    fi
fi

# 🧹 Kill any previous Xpra sessions
pkill -f xpra || true

# 🧱 Link persistent Fluxbox config from repo
WORKSPACE_DIR="/workspaces/$(basename $PWD)"
PERSISTENT_FLUXBOX="$WORKSPACE_DIR/.fluxbox"
HOME_FLUXBOX="$HOME/.fluxbox"

mkdir -p "$PERSISTENT_FLUXBOX"

if [ -d "$PERSISTENT_FLUXBOX" ]; then
    echo "🔗 Linking persistent Fluxbox config..."
    rm -rf "$HOME_FLUXBOX"
    ln -s "$PERSISTENT_FLUXBOX" "$HOME_FLUXBOX"
fi

# 🧰 Ensure base config exists (first run)
if [ ! -f "$PERSISTENT_FLUXBOX/menu" ]; then
    echo "🧩 Creating default Fluxbox config..."

    cat > "$PERSISTENT_FLUXBOX/menu" <<EOF
[begin] (Xpra Desktop)
    [exec] (Terminal) {xterm}
    [exec] (File Manager) {pcmanfm}
    [exec] (Google Chrome) {google-chrome --no-sandbox}
    [exec] (Text Editor) {mousepad}
    [separator]
    [exit] (Exit)
[end]
EOF

    cat > "$PERSISTENT_FLUXBOX/init" <<EOF
session.menuFile: ~/.fluxbox/menu
session.styleFile: /usr/share/fluxbox/styles/bloe
session.screen0.rootCommand: fbsetbg -solid '#2B2B2B'
EOF

    cat > "$PERSISTENT_FLUXBOX/startup" <<EOF
#!/bin/bash
fbsetbg -solid '#2B2B2B'
pcmanfm --desktop &
exec fluxbox
EOF
    chmod +x "$PERSISTENT_FLUXBOX/startup"
fi

# 🖥️ Start Xpra web desktop
echo "🚀 Launching Xpra web server..."
xpra start :100 \
  --bind-tcp=0.0.0.0:6080 \
  --html=on \
  --start-child="bash -c '~/.fluxbox/startup'" \
  --auth=none \
  --tcp-auth=none \
  --ws-auth=none \
  --no-mdns \
  --no-daemon \
  --exit-with-children=yes \
  --compression=off \
  --ssl=off \
  --sharing=yes \
  --bell=no \
  --notifications=no \
  --clipboard=yes &

echo "✅ Xpra desktop ready at: http://localhost:6080"
echo "💡 Right-click the background for Fluxbox menu."
