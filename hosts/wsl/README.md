# wsl

# :warning: Disclaimer

**I no longer use WSL and therefore can't guarrantee that this host works correctly.**

## Installation

Set up WSL from Windows (reboot Windows after the first step):

1. **Install and update WSL**

   ```powershell
   wsl --install --no-distribution
   wsl --update
   ```

2. **Import NixOS-WSL** — download the [latest installer](https://github.com/nix-community/NixOS-WSL)

   ```powershell
   wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
   ```

3. **Start a NixOS session**

   ```powershell
   wsl -d NixOS
   ```

Then clone this repo and rebuild:

```bash
git clone https://github.com/anders130/dotfiles
cd dotfiles
```

```bash
sudo nixos-rebuild switch --flake .#wsl
```

Finally restart WSL from Windows:

```powershell
wsl --shutdown
```
