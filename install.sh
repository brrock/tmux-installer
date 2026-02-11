#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
TEMP_DIR=$(mktemp -d)

cleanup() {
  rm -rf "${TEMP_DIR}"
}

trap cleanup EXIT

echo "Fetching latest tmux release..."

REPO="${GITHUB_REPO:-brrock/tmux-installer}"
echo "Using repository: $REPO"
RELEASE_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d '"' -f 4)

if [ -z "$RELEASE_URL" ]; then
  echo "Error: Could not find latest release"
  exit 1
fi

echo "Downloading from: $RELEASE_URL"
curl -L -o "${TEMP_DIR}/tmux-linux-amd64.tar.gz" "$RELEASE_URL"

echo "Extracting tmux..."
tar xzf "${TEMP_DIR}/tmux-linux-amd64.tar.gz" -C "${TEMP_DIR}"

if [ ! -f "${TEMP_DIR}/tmux" ]; then
  echo "Error: tmux binary not found in archive"
  exit 1
fi

echo "Installing tmux to ${INSTALL_DIR}..."

if [ -w "${INSTALL_DIR}" ]; then
  cp "${TEMP_DIR}/tmux" "${INSTALL_DIR}/"
  chmod +x "${INSTALL_DIR}/tmux"
else
  echo "Installing with sudo..."
  sudo cp "${TEMP_DIR}/tmux" "${INSTALL_DIR}/"
  echo "chmoding with sudo"
  sudo chmod +x "${INSTALL_DIR}/tmux"
fi


VERSION=$("${INSTALL_DIR}/tmux" -V)
echo "Successfully installed tmux: ${VERSION}"
