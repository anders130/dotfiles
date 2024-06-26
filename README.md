# My [NixOS](https://nixos.org/) Configuration

## Usage
To rebuild the this configuration simply use this command:
```fish
flake-rebuild
```
It will assume your host configuration name with the `$NIX_FLAKE_DEFAULT_HOST` environment variable.
If you want, you can also specify some options from the `nixos-rebuild` command like this:
```fish
flake-rebuild --fast --impure
```

## Installation (Desktop)
Install NixOS and follow the next steps:

Clone the repository into your home directory.
```bash
cd /home/<username>
nix-shell -p git --run "sudo git clone --recurse-submodules https://github.com/anders130/dotfiles.git .dotfiles"
```
Adjust the values inside `secrets.json` to fit your needs. Inside `flake.nix` change the hostname and username for the specific host configuration to your liking. 

Now rebuild the system and restart.
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles\?submodules=1#desktop
sudo reboot
```

## Installation (WSL)
Install and update WSL (if not already):
```powershell
wsl --install --no-distribution
wsl --update
```
Reboot windows for good measure.
Get the [latest NixOS-WSL installer](https://github.com/nix-community/NixOS-WSL) and install it:
```powershell
wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
```
Start a session with NixOS:
```powershell
wsl -d NixOS
```

Clone the repository into your home directory.
```bash
cd /home/<username>
nix-shell -p git --run "sudo git clone --recurse-submodules https://github.com/anders130/dotfiles.git .dotfiles"
```
Adjust the values inside `secrets.json` to fit your needs. Inside `flake.nix` change the hostname and username for the specific host configuration to your liking. 

Now rebuild the system.
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles\?submodules=1#wsl
```
Next restart WSL (from powershell):
```powershell
wsl --shutdown
```

## Installation on a Raspberry-Pi
Assuming you currently use the `desktop` configuration.
First build the Image for the SD-Card.
```bash
nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake ~/.dotfiles#nix-pi --system aarch64-linux -o ./nix-pi.sd
cp nix-pi.sd/sd-image/nixos-sd-image-name.img.zst ~/
unzstd -d nixos-sd-image-name.img.zst -o nix-pi-sd-image.img
```
Now install it on the SD-Card. To do that, insert the SD-Card into your machine and figure out the device name.
```bash
sudo fdisk -l
```
The `p1` and `p2` are just partitions on the device. To now write the image onto the SD-Card, run:
```bash
sudo dd if=/path/to/the/nix-pi-sd-image.img of=/dev/sdX bs=1M status=progress
```
Setup internet connection on the Raspberry Pi with:
```
nmcli device wifi connect <SSID> password <SSIDPassword>
```
### Update the configuration remotely
```bash
flake-remote-build nix-pi --target-host admin@domain
```
Then you need to put in the admins password multiple times and quit the task the second time.
