#!/bin/bash
set -e

VERSION="v1.0.0"
REPO="https://github.com/Mayank12agrawal/tf-select/releases/download/$VERSION"

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  # Fallback to amd64 binary for Apple Silicon Macs
  ARCH="amd64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

BINARY="tf-select-$OS-$ARCH"
URL="$REPO/$BINARY"

echo "Downloading $URL ..."
curl -fsSL -o tf-select "$URL"
chmod +x tf-select

# Default install directory
INSTALL_DIR="/usr/local/bin"

# Use local install directory if user passes --local or cannot sudo
if [[ "$1" == "--local" ]]; then
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
  mv tf-select "$INSTALL_DIR"
  echo "Installed to $INSTALL_DIR"
  echo "Make sure $INSTALL_DIR is in your PATH."
else
  # Try moving with sudo, fallback to local if sudo fails
  if sudo mv tf-select /usr/local/bin/tf-select; then
    echo "Installed to /usr/local/bin"
  else
    echo "Could not move to /usr/local/bin, installing to local directory instead."
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    mv tf-select "$INSTALL_DIR"
    echo "Installed to $INSTALL_DIR"
    echo "Make sure $INSTALL_DIR is in your PATH."
  fi
fi

echo "tf-select installed successfully
