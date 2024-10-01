# Desktop

This is the configuration of my main computer.

## Installation

To install NixOS on this machine, follow these steps:

1. **Boot into a live-usb**

   You can download an image from [nixos.org](https://nixos.org/download.html#nixos-usb).

2. **Clone this repository**

   ```bash
   nix-shell -p git --run "git clone https://github.com/anders130/dotfiles.git .dotfiles"
   cd .dotfiles
   ```

3. **Adjust the disk configuration**

   Update the `disk-config.nix` file to match your system's drives. Use `lsblk` to identify the available disks.

4. **Apply the disk configuration**

   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#workstation
   ```

5. **Verify disk setup**

   Ensure that the partitions are correctly mounted:

   ```bash
   mount | grep /mnt
   ```

6. **Install NixOS**

   ```bash
   nixos-install --flake .#desktop
   reboot
   ```
