# Raspberry Pi

To use this module, you need to explicitly import the `./_nixosSystemModule.nix` file in your host configuration.

```nix
{
    imports = [
        /path/to/this/module/_nixosSystemModule.nix
    ];
    modules = {
        hardware.raspberry-pi = {
            enable = true;
            spi.enable = true;
        };
    };
}
```
