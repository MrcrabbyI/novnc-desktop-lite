#!/usr/bin/env bash
set -e

# ================================
# == ENVIRONMENT VARIABLES / CONFIG ==
# ================================
NOVNC_PORT=${NOVNC_PORT:-6080}
VNC_PORT=${VNC_PORT:-5901}
NOVNC_PASSWORD=${NOVNC_PASSWORD:-vscode}
DESKTOP_ENV=FLUXBOX
CHROME_VERSION=STABLE
FILE_MANAGER=PCMANFM
ARCHITECTURE=$(dpkg --print-architecture)

echo "CONFIGURATION ;)"
echo "  - NOVNC_PORT=$NOVNC_PORT"
echo "  - VNC_PORT=$VNC_PORT"
echo "  - NOVNC_PASSWORD=$NOVNC_PASSWORD"
echo "  - DESKTOP_ENV=$DESKTOP_ENV"
echo "  - CHROME_VERSION=$CHROME_VERSION"
echo "  - FILE_MANAGER=$FILE_MANAGER"
echo "  - ARCHITECTURE=$ARCHITECTURE"

# ================================
# == SETUP ==
# ================================

echo "Updating packages..."
apt-get update

echo "Installing PCManFM (file manager)..."
if ! command -v pcmanfm >/dev/null 2>&1; then
  apt-get install -y pcmanfm
else
  echo "PCManFM already installed."
fi

echo "Installing Google Chrome..."
if ! command -v google-chrome >/dev/null 2>&1; then
  curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_${ARCHITECTURE}.deb -o /tmp/chrome.deb
  apt-get install -y /tmp/chrome.deb || apt-get -f install -y
  rm /tmp/chrome.deb
else
  echo "Google Chrome already installed."
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

echo "Setup complete! You can connect via VNC on port $VNC_PORT and web noVNC on port $NOVNC_PORT"
echo "Password for both: $NOVNC_PASSWORD"
echo "this took so long btw so give me a star"
