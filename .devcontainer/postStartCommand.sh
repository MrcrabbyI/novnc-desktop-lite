#!/bin/bash
set -e
echo "🚀 Starting Xpra 6.4 Fluxbox desktop..."

export DEBIAN_FRONTEND=noninteractive

# 🧱 Make sure everything we need is installed
apt-get update && apt-get install -y xpra fluxbox xterm pcmanfm mousepad wget gnupg2 curl

# 🧹 Kill any previous Xpra sessions
pkill -f xpra || true

# 🔗 Link persistent Fluxbox config
if [ -d "/workspaces/$(basename $PWD)/.fluxbox" ]; then
    echo "🔗 Using persistent Fluxbox config"
    rm -rf ~/.fluxbox
    ln -s /workspaces/$(basename $PWD)/.fluxbox ~/.fluxbox
else
    echo "🧱 Creating new Fluxbox config"
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
fi

# 🖥️ Start Xpra web desktop (disable all auth)
echo "🚀 Launching Xpra web server..."
xpra start :100 \
  --bind-tcp=0.0.0.0:6080 \
  --html=on \
  --start-child="bash -c '~/.fluxbox/startup'" \
  --auth=none \
  --tcp-auth=none \
  --ws-auth=none \
  --ssl=off \
  --no-mdns \
  --no-daemon \
  --exit-with-children=yes \
  --compression=off \
  --sharing=yes \
  --notifications=no \
  --clipboard=yes \
  --bell=no &

echo "✅ Xpra web desktop ready at: http://localhost:6080"
