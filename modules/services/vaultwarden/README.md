# vaultwarden

This module adds [vaultwarden](https://github.com/dani-garcia/vaultwarden) to your system.

## Usage

```nix
networking.domain = "example.com";
modules.services.vaultwarden.enable = true;
```

## Secrets

The secrets are stored in the `secrets.env` file.

To edit the secrets, run:

```bash
sops edit secrets.env
```

To update the secrets when adding a new device, run:

```bash
sops updatekeys secrets.env
```

### ADMIN_TOKEN

The admin token is used to login to the web interface. It is generated with `argon2` and is stored in the `secrets.env` file.

```bash
nix shell nixpkgs#libargon2 nixpkgs#openssl
echo -n "YourSecretPassword" | argon2 "$(openssl rand -base64 32)" -e -id -k 19456 -t 2 -p 1
```
