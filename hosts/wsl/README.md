# WSL

This is the configuration for my WSL (Windows Subsystem for Linux) setup.

## Installation

1. **Install and update WSL**

   If WSL is not already installed, install it and upate to the latest version:

   ```powershell
   wsl --install --no-distribution
   wsl --update
   ```

   Reboot windows for good measure.

2. **Download and install NixOS-WSL**

   Download the [latest NixOS-WSL installer](https://github.com/nix-community/NixOS-WSL) and import it into WSL:

   ```powershell
   wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
   ```

3. **Start a NixOS Session**

   ```powershell
   wsl -d NixOS
   ```

4. **Clone the repository**

   Inside the new NixOS environment, clone this repository into your home directory:

   ```bash
   cd /home/<username>
   nix-shell -p git --run "git clone https://github.com/anders130/dotfiles.git .dotfiles"
   ```

5. **Rebuild the System**

   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles#wsl
   ```

6. **Restart WSL**

   Finally, shut down and restart WSL for the changes to take effect:

   ```powershell
   wsl --shutdown
   ```
