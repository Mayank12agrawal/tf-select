#!/bin/bash
set -e

VERSION="v1.0.0"
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then ARCH="amd64"; fi

URL="https://github.com/Mayank12agrawal/tf-select/releases/download/$VERSION/tf-select-$OS-$ARCH"

echo "⬇️ Downloading tf-select from $URL ..."

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

curl -fsSL "$URL" -o "$INSTALL_DIR/tf-select"
chmod +x "$INSTALL_DIR/tf-select"

echo "✅ Installed tf-select to $INSTALL_DIR"

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo "WARNING: $INSTALL_DIR is not in your PATH."
  echo "Add this line to your shell profile (~/.bashrc or ~/.zshrc):"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

tf-select --help
