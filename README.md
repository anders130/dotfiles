# My [NixOS](https://nixos.org/) Configuration

Built with [Nix flakes](https://wiki.nixos.org/wiki/Flakes) and the [den](https://github.com/denful/den) framework.

- [./hosts](./hosts): Host configurations.
- [./modules](./modules): Modules shared between hosts.
- [./templates](./templates): Templates for flake-based projects.

## Hosts

- [jesse-desktop](./hosts/jesse-desktop)
- [workstation](./hosts/workstation)
- [wsl](./hosts/wsl)

## Usage

### Unfree packages

Run an unfree package without permanently allowing it:

```fish
nix run nixpkgs#unfreePackage --unfree
```

### Flake update tokens

To avoid GitHub rate limits when updating flake inputs, add a token to `~/.nix.conf` (included automatically when present):

```conf
access-tokens = github.com=ghp_***
```

### Rebuilding

Rebuild the current host (taken from `$NIX_FLAKE_DEFAULT_HOST`):

```fish
rebuild
```

A different subcommand or extra arguments work too:

```fish
rebuild boot --impure
```
