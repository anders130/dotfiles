# nix-pi

This is the configuration of my Raspberry Pi.

## Installation

To install NixOS on this machine, follow these steps:

1. **build the image**

   ```bash
   nix build '.#nixosConfigurations.nix-pi.config.system.build.sdImage'
   ```

2. **copy the image to the SD-Card**

   Uncompress the image:

   ```bash
   cp ./result/sd-image/nixos-sd-image-name.img.zst .
   unzstd -d nixos-sd-image-name.img.zst -o nix-pi-sd-image.img
   ```

   Insert the SD-Card into your machine and figure out the device name.

   ```bash
   sudo fdisk -l
   ```

   The `p1` and `p2` are just partitions on the device. To now write the image onto the SD-Card, run:

   ```bash
   sudo dd if=nix-pi-sd-image.img of=/dev/sdX bs=1M status=progress
   ```

3. **Setup internet connection**

   ```
   nmcli device wifi connect <SSID> password <SSIDPassword>
   ```

## Update the configuration remotely

```bash
rebuild --host nix-pi --target-host admin@domain
```
