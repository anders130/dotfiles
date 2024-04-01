# My [NixOS](https://nixos.org/) Configuration

## Usage
To rebuild the this configuration simply use this command:
```fish
flake-rebuild
```
Without arguments it will assume your host configuration name with the `$NIX_FLAKE_DEFAULT_HOST` environment variable.
If you want, you can also specify the host configuration name and use some options from the `nixos-rebuild switch` command like this:
```fish
flake-rebuild <hostname> --fast --impure
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
sudo nixos-rebuild switch --flake ~/.dotfiles\?submodules=1#linux
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

