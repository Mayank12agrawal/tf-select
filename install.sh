#!/usr/bin/env bash
set -euo pipefail

# Version logic: positional argument > environment variable > 'latest'
VERSION="${1:-${TFSELECT_VERSION:-latest}}"

REPO="Mayank12agrawal/tf-select"
BINARY="tf-select"

# Detect OS (lowercase) and normalize architecture names
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "❌ Unsupported architecture: $ARCH"
  exit 1
fi

# Resolve latest version using GitHub API if needed
if [[ "$VERSION" == "latest" ]]; then
  VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | \
    grep -m1 '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [[ -z "$VERSION" ]]; then
    echo "❌ Could not fetch latest version of $REPO"
    exit 1
  fi
fi

TARBALL="${BINARY}_${VERSION#v}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${TARBALL}"

echo "📥 Checking if asset $TARBALL exists at $URL..."

if ! curl -fsI "$URL" > /dev/null; then
  echo "❌ Release asset not found:"
  echo "   $URL"
  echo "❓ Please verify the release exists and asset is uploaded."
  exit 1
fi

echo "⬇️ Downloading $TARBALL..."
curl -fLo "$TARBALL" "$URL"

echo "📦 Extracting binary $BINARY..."
tar -xzf "$TARBALL"

chmod +x "$BINARY"

echo "🛠 Installing $BINARY to /usr/local/bin (requires sudo if needed)..."
if mv "$BINARY" /usr/local/bin/ 2>/dev/null; then
  echo "✅ Installed to /usr/local/bin without sudo."
else
  echo "🔐 Moving with sudo..."
  sudo mv "$BINARY" /usr/local/bin/
  echo "✅ Installed to /usr/local/bin with sudo."
fi

rm -f "$TARBALL"

echo "🎉 $BINARY $VERSION installed successfully!"
echo "👉 Run '$BINARY --help' to get started."
$BINARY --help
