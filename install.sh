# Set variables
VERSION="v1.0.0"
REPO="Mayank12agrawal/tf-select"
BINARY="tf-select"

# Detect OS and architecture
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architecture
if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then ARCH="arm64"; fi
if [[ "$ARCH" == "i386" ]]; then ARCH="386"; fi

# Define tarball name
TARBALL="${BINARY}_${VERSION}_${OS}_${ARCH}.tar.gz"

# Download URL
URL="https://github.com/${REPO}/releases/download/${VERSION}/${TARBALL}"

# Download, extract, install
curl -fLo "$TARBALL" "$URL"
tar -xzf "$TARBALL"
chmod +x "$BINARY"

# Install to /usr/local/bin
if mv "$BINARY" /usr/local/bin/ 2>/dev/null; then
  echo "Installed without sudo."
else
  sudo mv "$BINARY" /usr/local/bin/
  echo "Installed with sudo."
fi

rm "$TARBALL"
