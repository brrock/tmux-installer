#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"

echo "Installing dependencies..."

if command -v apt-get &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y autoconf automake pkg-config libevent-dev libncurses-dev bison byacc wget
elif command -v yum &> /dev/null; then
  sudo yum install -y autoconf automake pkgconfig libevent-devel ncurses-devel bison byacc wget
elif command -v dnf &> /dev/null; then
  sudo dnf install -y autoconf automake pkgconfig libevent-devel ncurses-devel bison byacc wget
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm autoconf automake pkg-config libevent ncurses bison byacc wget
else
  echo "Unsupported package manager. Please install autoconf, automake, pkg-config, wget, libevent, and ncurses manually."
  exit 1
fi

echo "Building static libevent..."

cd /tmp
wget -q https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar xzf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure --disable-shared --enable-static --prefix=/tmp/libevent-static >/dev/null
make -j$(nproc) >/dev/null
make install >/dev/null

echo "Building static ncurses..."

cd /tmp
wget -q https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz
tar xzf ncurses-6.5.tar.gz
cd ncurses-6.5
./configure --disable-shared --enable-static --without-shared --with-curses-h --prefix=/tmp/ncurses-static >/dev/null
make -j$(nproc) >/dev/null
make install >/dev/null

echo "Cloning tmux repository..."

cd "${SCRIPT_DIR}"
rm -rf "${BUILD_DIR}"
git clone https://github.com/tmux/tmux.git "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "Building tmux (static)..."

export PKG_CONFIG_PATH="/tmp/libevent-static/lib/pkgconfig:/tmp/ncurses-static/lib/pkgconfig"
export CFLAGS="-I/tmp/ncurses-static/include -I/tmp/libevent-static/include"
export LDFLAGS="-L/tmp/ncurses-static/lib -L/tmp/libevent-static/lib -static-libgcc"

sh autogen.sh
./configure --enable-static
make -j$(nproc) >/dev/null

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