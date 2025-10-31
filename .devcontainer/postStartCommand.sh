#!/bin/bash
set -e
echo "🚀 Starting Xpra desktop service..."

export DEBIAN_FRONTEND=noninteractive

# 🧱 Ensure dependencies
if ! command -v xpra >/dev/null 2>&1; then
    echo "📦 Installing Xpra + desktop tools..."
    apt-get update && apt-get install -y xpra fluxbox xterm pcmanfm wget gnupg2 curl mousepad
fi

# 🧹 Kill any old sessions
pkill -f xpra || true

# 🧰 Fluxbox setup
mkdir -p ~/.fluxbox

cat > ~/.fluxbox/menu <<EOF
[begin] (Xpra Desktop)
    [exec] (Terminal) {xterm}
    [exec] (File Manager) {pcmanfm}
    [exec] (Text Editor) {mousepad}
    [separator]
    [exit] (Exit)
[end]
EOF

cat > ~/.fluxbox/init <<EOF
session.menuFile: ~/.fluxbox/menu
session.styleFile: /usr/share/fluxbox/styles/bloe
session.screen0.rootCommand: fbsetbg -solid '#2B2B2B'
EOF

cat > ~/.fluxbox/startup <<EOF
#!/bin/bash
fbsetbg -solid '#2B2B2B'
pcmanfm --desktop &
exec fluxbox
EOF
chmod +x ~/.fluxbox/startup

# 🧩 Make sure Xpra config disables auth
mkdir -p ~/.xpra
cat > ~/.xpra/config <<EOF
auth=none
tcp-auth=none
ws-auth=none
html=on
ssl=off
EOF

# 🖥️ Start Xpra web server
echo "🚀 Launching Xpra web server (no auth)..."
xpra start :100 \
  --bind-tcp=0.0.0.0:6080 \
  --start-child="$HOME/.fluxbox/startup" \
  --html=on \
  --auth=none \
  --tcp-auth=none \
  --ws-auth=none \
  --mdns=no \
  --ssl=off \
  --no-daemon \
  --exit-with-children=yes \
  --sharing=yes \
  --notifications=no \
  --bell=no \
  --clipboard=yes \
  --dbus=no \
  --systemd-run=no

echo "✅ Xpra desktop running at: http://localhost:6080"
