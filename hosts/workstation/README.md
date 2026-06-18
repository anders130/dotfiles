# workstation

This is the configuration for my work laptop.

## Installation

Boot a NixOS live USB and clone this repo:

```bash
git clone https://github.com/anders130/dotfiles
cd dotfiles
```

### DisplayLink driver

This configuration enables the DisplayLink module. The driver is unfree and must be fetched into the store before installing:

```bash
nix-prefetch-url --name displaylink-620.zip https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip
```

Partition (**erases the disks below**) and install:

| Disk  | Size | Format | Mount |
| ----- | ---- | ------ | ----- |
| nixos | 512M | vfat   | /boot |
| nixos | 100% | -      | -     |

```bash
sudo nix run github:nix-community/disko -- --mode disko --flake .#workstation
nixos-install --flake .#workstation
```

## Setup Secure-Boot

Set a **BIOS password** and disable **key protection** in the BIOS (usually `F2` during boot).

1. **Create secure boot keys**

   ```bash
   sudo nix run nixpkgs#sbctl create-keys
   sudo nix run nixpkgs#sbctl verify
   ```

2. **Enable Secure-Boot in the BIOS** — enable **Secure-Boot** and check **clear keys on next boot**, then restart.

3. **Enroll Secure-Boot keys**

   ```bash
   sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
   ```

4. **Verify** after a reboot

   ```bash
   bootctl status
   ```

## Setup Fingerprint Reader

Check the reader is detected, then enroll and verify:

```bash
fprintd-list <username>
fprintd-enroll
fprintd-verify
```
