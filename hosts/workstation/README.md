# Workstation

This is the configuration for my work laptop.

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
   nixos-install --flake .#workstation
   reboot
   ```

## Setup Secure-Boot

To enable Secure Boot, you’ll need to set a **BIOS password** and disable **key protection**. You can do this by entering the BIOS (usually by pressing `F2` during boot) and following the on-screen instructions.

### Steps to set up Secure-Boot

1. **Create secure boot keys**

   ```bash
   sudo nix run nixpkgs#sbctl create-keys
   ```

   After this, verify that the keys are created successfully:

   ```bash
   sudo nix run nixpkgs-unstable#sbctl verify
   ```

2. **Enable Secure-Boot in the BIOS**

   Enter BIOS, enable **Secure-Boot** and check the box **clear keys on next boot**.
   Then restart the computer.

3. **Enroll Secure-Boot keys**

   ```bash
   sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
   ```

4. **Verify Secure-Boot Status**

   After a reboot you can verify the keys:

   ```bash
   bootctl status
   ```
