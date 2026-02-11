# tmux Installer

Automated build and installation of tmux for Linux AMD64.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | bash
```

This will:
- Download the latest tmux binary release
- Install it to `/usr/local/bin/tmux`

## Custom Install Location

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | bash -s
```

Or set `INSTALL_DIR` environment variable:

```bash
curl -fsSL https://raw.githubusercontent.com/brrock/tmux-installer/main/install.sh | INSTALL_DIR=$HOME/bin bash -s
```

## Dependencies

none, static binary
