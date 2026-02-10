# tmux Installer

Automated build and installation of tmux for Linux AMD64.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | bash
```

This will:
- Download the latest tmux binary release
- Install it to `/usr/local/bin/tmux`
- Check for required dependencies (libevent, ncurses)

## Custom Install Location

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | bash -s
```

Or set `INSTALL_DIR` environment variable:

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | bash -s && INSTALL_DIR=$HOME/bin bash install.sh
```

## Dependencies

tmux requires these libraries (usually pre-installed on Linux):
- libevent
- ncurses

If missing, the installer will show how to install them:
- Ubuntu/Debian: `sudo apt-get install libevent-2.1-7 libncurses6`
- CentOS/RHEL: `sudo yum install libevent ncurses-libs`
- Fedora: `sudo dnf install libevent ncurses-libs`
- Arch: `sudo pacman -S libevent ncurses`
