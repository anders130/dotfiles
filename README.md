# My [NixOS](https://nixos.org/) Configuration

## About

This repository contains all my NixOS configurations. It uses [Nix flakes](https://nixos.wiki/wiki/Flakes) to manage the configurations. <br>
To create the hosts and modules I use the nix-library [modulix](https://github.com/anders130/modulix).

- [./hosts](./hosts): Contains the configurations for my different hosts.
- [./modules](./modules): Contains the modules for my different hosts.
- [./overlays](./overlays): Contains overlays for various packages that I use.
- [./pkgs](./pkgs): Contains package definitions for some packages that are/were not in nixpkgs.
- [./templates](./templates): Contains templates for some flake-based projects.

## Usage

To rebuild this configuration simply use this command:

```fish
rebuild
```

It will assume your host configuration name with the `$NIX_FLAKE_DEFAULT_HOST` environment variable.
If you want, you can choose a different rebuild subcommand, you can even specify additional arguments:

```fish
rebuild boot --impure
```

---

If you encounter rate limiting while updating flake inputs, you can add your github token via `~/.config/nix/nix.conf`:

```conf
access-tokens = github.com=ghp_***
```

To create a new token, go to [github.com/settings/tokens](https://github.com/settings/tokens) and click on `Generate new token`.

## Installation

You can find installation guides for each host in the directory of the host (e. g. [./hosts/desktop](./hosts/desktop)).
