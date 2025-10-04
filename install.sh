#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-v1.0.0}"
REPO="Mayank12agrawal/tf-select"
BINARY="tf-select"

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then ARCH="arm64"; fi
if [[ "$ARCH" == "i386" ]]; then ARCH="386"; fi

# Notice the extra underscore after binary and before version tag
TARBALL="${BINARY}_v${VERSION#v}_${OS}_${ARCH}.tar.gz"

URL="https://github.com/${REPO}/releases/download/${VERSION}/${TARBALL}"

echo "📥 Checking if asset $TARBALL exists at $URL..."

if ! curl -fsI "$URL" > /dev/null; then
  echo "❌ Release asset not found:"
  echo "   $URL"
  exit 1
fi

echo "⬇️ Downloading $TARBALL ..."
curl -fLo "$TARBALL" "$URL"

echo "📦 Extracting $BINARY from $TARBALL ..."
tar -xzf "$TARBALL"

chmod +x "$BINARY"

echo "🛠 Installing $BINARY to /usr/local/bin (may require sudo)..."
if mv "$BINARY" /usr/local/bin/ 2>/dev/null; then
  echo "✅ Installed without sudo."
else
  echo "🔐 Installing with sudo..."
  sudo mv "$BINARY" /usr/local/bin/
  echo "✅ Installed with sudo."
fi

rm -f "$TARBALL"

echo "🎉 $BINARY $VERSION installed successfully!"
$BINARY --help
