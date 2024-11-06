# Sops

This module adds secrets management with [Sops](https://github.com/Mic92/sops-nix).

## Usage

```nix
modules.sops.enable = true;
```

Generate the `keys.txt`:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

For more information, see the [Sops documentation](https://github.com/Mic92/sops-nix).
