#!/usr/bin/env bash
set -e

NOVNC_PORT=${NOVNC_PORT:-6080}
VNC_PORT=${VNC_PORT:-5901}
NOVNC_PASSWORD=${NOVNC_PASSWORD:-vscode}
DESKTOP_ENV=FLUXBOX
ARCHITECTURE=$(dpkg --print-architecture)
FILE_MANAGER=PCMANFM

echo "CONFIGURATION:"
echo "  - NOVNC_PORT=$NOVNC_PORT"
echo "  - VNC_PORT=$VNC_PORT"
echo "  - NOVNC_PASSWORD=$NOVNC_PASSWORD"
echo "  - DESKTOP_ENV=$DESKTOP_ENV"
echo "  - FILE_MANAGER=$FILE_MANAGER"
echo "  - ARCHITECTURE=$ARCHITECTURE"

echo "Updating packages..."
apt-get update

echo "Installing PCManFM..."
if ! command -v pcmanfm >/dev/null 2>&1; then
  apt-get install -y pcmanfm
fi

echo "Installing Google Chrome..."
if ! command -v google-chrome >/dev/null 2>&1; then
  curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_${ARCHITECTURE}.deb \
    -o /tmp/chrome.deb
  apt-get install -y /tmp/chrome.deb || apt-get -f install -y
  rm /tmp/chrome.deb
fi

echo "Setting up Fluxbox menu..."
mkdir -p /root/.fluxbox
cat > /root/.fluxbox/menu <<EOF
[begin] (fluxbox)
  [exec] (Google Chrome) {google-chrome --no-sandbox}
  [exec] (File Manager) {pcmanfm}
  [restart] (Restart)
  [exit] (Exit)
[end]
EOF

echo "Install finished! noVNC on port $NOVNC_PORT, VNC on $VNC_PORT"
