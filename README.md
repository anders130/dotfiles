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

If you encounter rate limiting while updating flake inputs, you can add your github token via `~/.config/nix/nix.conf`:

```
access-tokens = github.com=ghp_***
```

To create a new token, go to [github.com/settings/tokens](https://github.com/settings/tokens) and click on `Generate new token`.

Adjust the values inside `secrets.json` to fit your needs.

## Installation

You can find installation guides for the different configurations in the [hosts](./hosts) directory.

### Installation on a Raspberry-Pi

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
# or
nixos-rebuild switch --flake .#nix-pi --target-host admin@domain
```
