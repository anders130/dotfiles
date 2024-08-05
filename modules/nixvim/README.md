# My Nixvim configuration

To start this custom neovim installation, run one of the following commands:

```bash
# upstream version
nix run "github:anders130/dotfiles?dir=modules/nixvim"

# local version
nix run .
```

To test the changes in this configuration, run the following command:

```bash
nix flake check .
```
