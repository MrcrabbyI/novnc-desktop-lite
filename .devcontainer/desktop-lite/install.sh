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
# == REAL SETUP BEGINS HERE ==
# ================================

# Update packages
apt-get update

# Install necessary packages for desktop, VNC, noVNC, fluxbox, file manager
apt-get install -y fluxbox tigervnc-standalone-server tigervnc-common \
  x11-xserver-utils xterm wget curl net-tools \
  python3-websockify novnc pcmanfm

# Setup VNC password
mkdir -p /root/.vnc
echo "$NOVNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Setup noVNC to run on NOVNC_PORT
# Clone noVNC if not present
if [ ! -d /opt/noVNC ]; then
  git clone https://github.com/novnc/noVNC.git /opt/noVNC
fi

# Run noVNC on the specified port in background
# (You might want to put this in a systemd service or supervisor in real use)
nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NOVNC_PORT &

# install chrome
if ! command -v google-chrome &> /dev/null; then
  curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_${ARCHITECTURE}.deb -o /tmp/chrome.deb
  apt-get install -y /tmp/chrome.deb || apt-get -f install -y
  rm /tmp/chrome.deb
fi

# Create ./fluxbox menu to include Chrome and PCManFM
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
