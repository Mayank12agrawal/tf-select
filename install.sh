#!/bin/bash
set -e

VERSION="v1.0.0"
REPO="https://github.com/Mayank12agrawal/tf-select/releases/download/$VERSION"

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

BINARY="tf-select-$OS-$ARCH"
URL="$REPO/$BINARY"

echo "Downloading $URL ..."
curl -fsSL -o tf-select "$URL"
chmod +x tf-select
sudo mv tf-select /usr/local/bin/tf-select

echo "tf-select installed successfully!"
tf-select --help
