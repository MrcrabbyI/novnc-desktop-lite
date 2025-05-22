#!/bin/bash
set -e

# Define variables
FEATURE_URL="https://github.com/devcontainers/features/archive/refs/heads/main.zip"
TMP_DIR="/tmp/devcontainer-features-main"
TARGET_DIR=".devcontainer/desktop-lite"

curl -L $FEATURE_URL -o features.zip

unzip -q features.zip -d /tmp

echo "Copying desktop-lite feature into $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
cp -r "$TMP_DIR/src/desktop-lite/"* "$TARGET_DIR/"


rm -rf features.zip "$TMP_DIR"

echo "Done desktop-lite into $TARGET_DIR"

# Check for git repo
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "committing and pushing to GitHub..."

    git add "$TARGET_DIR"
    git commit -m "feat: localize desktop-lite feature into devcontainer"
    git push

    echo "All done."
else
    echo "Not inside a git repo. Skipping push."
fi
