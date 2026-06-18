# jesse-desktop

This is the configuration of my main computer.

## Installation

Boot a NixOS live USB and clone this repo:

```bash
git clone https://github.com/anders130/dotfiles
cd dotfiles
```

Partition (**erases the disks below**) and install:

| Disk  | Size | Format | Mount |
| ----- | ---- | ------ | ----- |
| data  | 100% | btrfs  | -     |
| games | 100% | ext4   | -     |
| nixos | 512M | vfat   | /boot |
| nixos | 100% | ext4   | /     |

```bash
sudo nix run github:nix-community/disko -- --mode disko --flake .#jesse-desktop
nixos-install --flake .#jesse-desktop
```

## WinApps

Start the Windows VM:

```bash
systemctl start WinApps
```

Open the noVNC web interface at <http://localhost:8006>, then wait for the download to finish and Windows to install (may take a while).

Set up the `.desktop` files winapps creates:

```bash
winapps-setup
```

1. Select `Install`
2. Select `System`
3. Select `Automatic`
