#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"

echo "Installing dependencies..."

if command -v apt-get &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y autoconf automake pkg-config libevent-dev libncurses-dev bison byacc
elif command -v yum &> /dev/null; then
  sudo yum install -y autoconf automake pkgconfig libevent-devel ncurses-devel bison byacc
elif command -v dnf &> /dev/null; then
  sudo dnf install -y autoconf automake pkgconfig libevent-devel ncurses-devel bison byacc
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm autoconf automake pkg-config libevent ncurses bison byacc
else
  echo "Unsupported package manager. Please install autoconf, automake, pkg-config, libevent, and ncurses manually."
  exit 1
fi

echo "Cloning tmux repository..."

rm -rf "${BUILD_DIR}"
git clone https://github.com/tmux/tmux.git "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "Building tmux..."

sh autogen.sh
./configure
make -j$(nproc)

VERSION=$(./tmux -V | sed 's/tmux //')
echo "Built tmux ${VERSION}"

echo "Creating release directory..."

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"
strip tmux
cp tmux "${INSTALL_DIR}/"
tar czf "${SCRIPT_DIR}/tmux-linux-amd64.tar.gz" -C "${INSTALL_DIR}" tmux

echo "Binary created: ${SCRIPT_DIR}/tmux-linux-amd64.tar.gz"
echo "tmux version: ${VERSION}"